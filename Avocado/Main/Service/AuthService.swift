//
//  AuthService.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/23.
//

import Foundation
import Amplify
import AWSPluginsCore
import AWSCognitoAuthPlugin
import RxSwift
import UIKit

/**
 * - Description 인증관련 API
 */
final class AuthService: BaseAPIService<AuthAPI> {
    
    // Observable처리 disposeBag
    private let disposeBag = DisposeBag()
    /**
     * - Description: 회원가입
     * - Parameter email: 로그인에 사용될 이메일
     * - Parameter password: 로그인에 사용될 패스워드
     * - Returns 회원가입 성공여부 Observerble
     */
    func signUp(email: String, password: String) -> Observable<Bool> {
        
        return Observable.create { observer in
            Task {
                let userAttr = [AuthUserAttribute(.email, value: email)]
                let options = AuthSignUpRequest.Options(userAttributes: userAttr)
                
                do {
                    let signUpResult = try await Amplify.Auth.signUp(username: email, password: password, options: options)
                    
                    if case let .confirmUser(deliveryDetails, _, userid) = signUpResult.nextStep {
                        Logger.d("Delivery details \(String(describing: deliveryDetails)) for userId \(String(describing: userid))")
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                    else {
                        Logger.d("SignUpComplted")
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                }
                catch let error as AuthError {
                    Logger.e("An error occurred while registering a user \(error)")
                    observer.onError(error)
                }
                catch {
                    Logger.e("Unexpected Error \(error)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
        
        
    }
    /**
     * - Description : 회원가입 후 이메일 인증
     * - Parameter email: 회원가입에 사용된 이메일
     * - Parameter confirmationCode: 인증번호
     * - Returns 이메일 인증 성공여부 Observable
     */
    func confirmSignUp(for email: String, with confirmationCode: String) -> Observable<Bool> {
        return Observable.create { observer in
            Task {
                do {
                    let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(for: email, confirmationCode: confirmationCode)
                    Logger.d("Confirm signUp result Complted \(confirmSignUpResult.isSignUpComplete)")
                    observer.onNext(confirmSignUpResult.isSignUpComplete)
                    observer.onCompleted()
                }
                catch let error as AuthError {
                    Logger.e("An error occurred while confirming sign up \(error)")
                    observer.onError(error)
                }
                catch {
                    Logger.e("Unexpected error \(error)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /**
     * - Description 로그인
     * - Parameter email: 로그인 이메일
     * - Parameter password: 로그인 패스워드
     * - Returns 로그인 성공여부 Observable
     */
    func login(email: String, password: String) -> Observable<Bool> {
        return Observable.create { observer in
            Task {
                do {
                    let loginResult = try await Amplify.Auth.signIn(username: email, password: password)
                    
                    if (loginResult.isSignedIn) {
                        // authToken 생성
                        let isSuccess = await self.authTokenGenerate()
                        observer.onNext(isSuccess)
                        observer.onCompleted()
                    }
                }
                catch let error as AuthError {
                    Logger.e("sign in failed \(error)")
                    
                    guard let cognitoAuthError = error.underlyingError as? AWSCognitoAuthError else {
                        observer.onError(error)
                        return
                    }
                    
                    let convertError = self.cognitoAuthErrorHandling(error: cognitoAuthError)
                    
                    observer.onError(convertError)
                }
                catch {
                    Logger.e("Unexpected error \(error)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /**
     * - Description 로그아웃
     * - Returns 로그아웃 성공여부 Observable
     */
    func logout() -> Observable<Bool> {
        
        return Observable.create { observer in
            Task {
                let result = await Amplify.Auth.signOut()
                guard let signOutResult = result as? AWSCognitoSignOutResult else {
                    observer.onError( NetworkError.unknown(-1, "signOut Faild"))
                    return Disposables.create()
                }
                
                switch signOutResult {
                case .complete:
                    Logger.d("signOut Success")
                    // accessToken, refreshToken delete
                    let isDeleted = KeychainUtil.loginTokenDelete()
                    if (!isDeleted) {
                        observer.onError(NetworkError.unknown(-1, "키체인 삭제 실패"))
                    }
                    else {
                        observer.onNext(true)
                    }
                    
                    observer.onCompleted()
                    
                case let .partial(revokeTokenError, globalSignOutError, _):
                    // accessToken, refreshToken delete
                    KeychainUtil.loginTokenDelete()
                    
                    // 각종 에러 처리
                    if let revokeTokenError = revokeTokenError {
                        Logger.e("revokeToken Error \(revokeTokenError)")
                        observer.onNext(false)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                    
                    if let globalSignOutError = globalSignOutError {
                        Logger.e("globalSignOut Error \(globalSignOutError)")
                        observer.onNext(false)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                    
                    //에러가 없을 경우
                    observer.onNext(true)
                    observer.onCompleted()
                    
                    
                case let .failed(error):
                    Logger.e("Sign Out failed with \(error)")
                    observer.onError(error)
                }
                
                return Disposables.create()
            }
            
            return Disposables.create()
        }
    }
    
    /**
     * - Description 계정삭제 (탈퇴)
     * - Returns 계정 탈퇴 여부 Observable
     */
    func deleteAccount() -> Observable<Bool> {
        return Observable.create { observer in
            Task {
                do {
                    try await Amplify.Auth.deleteUser()
                    Logger.d("Successed Deleted Account")
                    // accessToken, refreshToken delete
                    let isDeleted = KeychainUtil.loginTokenDelete()
                    if (!isDeleted) {
                        observer.onError(NetworkError.unknown(-1, "키체인 삭제 실패"))
                    }
                    else {
                        observer.onNext(true)
                    }
                    
                    observer.onCompleted()
                }
                catch let error as AuthError {
                    Logger.e("Delete account faild with error \(error)")
                    observer.onError(error)
                }
                catch {
                    Logger.e("Unexpected error \(error)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /**
     * - Description 패스워드 초기화
     * - Parameter email: 재설정 시 이메일 인증에 사용될 이메일
     * - Returns 패스워드 초기화 성공여부 Observable
     */
    func resetPassword(email: String) -> Observable<Bool> {
        
        return Observable.create { observer in
            Task {
                do {
                    let resetPasswordResult = try await Amplify.Auth.resetPassword(for: email)
                    Logger.d("Success Reset Password")
                    Logger.d("Next Step \(resetPasswordResult.nextStep)")
                    
                    switch resetPasswordResult.nextStep {
                    case let .confirmResetPasswordWithCode(deliveryDetail, info):
                        Logger.d("Confirm reset with code send to \(String(describing: deliveryDetail)) \(String(describing: info))")
                        observer.onNext(true)
                        
                    case .done:
                        observer.onNext(true)
                    }
                    
                    observer.onCompleted()
                }
                catch let error as AuthError {
                    Logger.e("Reset password failed \(error)")
                    observer.onError(error)
                }
                catch {
                    Logger.e("Unexpected error \(error)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /**
     * - Description 패스워드 초기화 후 패스워드 재설정
     * - Parameter email 이메일인증에 사용된 이메일
     * - Parameter newPassword 재설정할 패스워드
     * - Parameter confirmationCode 인증번호
     * - Returns 패스워드 재설정 여부 Observable
     */
    func confirmResetPassword(email: String, newPassword: String, confirmationCode: String) -> Observable<Bool> {
        return Observable.create { observer in
            Task {
                do {
                    try await Amplify.Auth.confirmResetPassword(for: email, with: newPassword, confirmationCode: confirmationCode)
                    Logger.d("Password reset confirm !")
                    observer.onNext(true)
                    observer.onCompleted()
                }
                catch let error as AuthError {
                    Logger.e("Reset password failed \(error)")
                    observer.onError(error)
                }
                catch {
                    Logger.e("Unexpected error \(error)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /**
     * - Description 비밀번호 변경하기
     * - Parameter oldPassword 변경 전 패스워드
     * - Parameter newPassword 변경 후 패스워드
     * - Returns 비밀번호 변경 여부 Observable
     */
    func changePassword(oldPassword: String, newPassword: String) -> Observable<Bool> {
        return Observable.create { observer in
            Task {
                do {
                    try await Amplify.Auth.update(oldPassword: oldPassword, to: newPassword)
                    Logger.d("Change password successed")
                    observer.onNext(true)
                    observer.onCompleted()
                }
                catch let error as AuthError {
                    Logger.e("Change password failed with error \(error)")
                    observer.onError(error)
                }
                catch {
                    Logger.e("Unexpected error \(error)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /**
     * - Description 엑세스, 리프레시 토큰 재발급
     * - Returns 엑세스, 리프레시 토큰 재발급 여부 Observable
     */
    func retryAuthToken() -> Observable<Bool> {
        
        return Observable.create { observer in
            Task {
                let session = try await Amplify.Auth.fetchAuthSession()
                if let cognitTokenResult = (session as? AuthCognitoTokensProvider)?.getCognitoTokens() {
                    switch cognitTokenResult {
                    case let .success(tokens):
                        KeychainUtil.loginAccessTokenUpdate(token: tokens.accessToken)
                        KeychainUtil.loginRefreshTokenUpdate(token: tokens.refreshToken)
                        
                        observer.onNext(true)
                        observer.onCompleted()
                        
                    case let .failure(error):
                        Logger.e("token retry failed with error \(error)")
                        observer.onError(error)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    /**
     * - Description 현재 사용자가 로그인했는지 안했는지 여부 판정, 액세스 토큰이 만료가 된 경우 토큰 갱신
     * - Returns 로그인 여부 Observable
     */
    func checkLoginSession() -> Observable<Bool> {
        
        return Observable.create { observer in
            Task {
                do {
                    let session = try await Amplify.Auth.fetchAuthSession()
                    Logger.d("Is user signed in - \(session.isSignedIn)")
                    
                    // 사용자가 로그아웃을 하지 않은 경우
                    if (session.isSignedIn) {
                        if let cognitTokenResult = (session as? AuthCognitoTokensProvider)?.getCognitoTokens() {
                            switch cognitTokenResult {
                            case let .success(tokens):
                                let readToken = KeychainUtil.loginAccessTokenRead()
                                
                                // accessToken 값이 다를 경우에만 토큰 업데이트
                                if (tokens.accessToken != readToken) {
                                    KeychainUtil.loginAccessTokenUpdate(token: tokens.accessToken)
                                    Logger.i("Not Same Access Token")
                                }
                                
                                observer.onNext(true)
                                
                            case let .failure(error):
                                Logger.e("token retry failed with error \(error)")
                                observer.onError(error)
                            }
                        }
                    }
                    else {
                        Logger.e("User Signed Failed !!")
                        observer.onNext(false)
                    }
                    
                    observer.onCompleted()
                }
                catch let error as AuthError {
                    Logger.e("Fetch session faild with error \(error)")
                    
                    guard let cognitoAuthError = error.underlyingError as? AWSCognitoAuthError else {
                        observer.onError(error)
                        return
                    }
                    
                    let convertError = self.cognitoAuthErrorHandling(error: cognitoAuthError)
                    
                    observer.onError(convertError)
                }
                catch {
                    Logger.e("Unexpected error: \(error)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    /**
     * - Description 이메일 인증번호 재요청
     * - Parameter to 재인증받을 이메일 인증 번호
     * - Returns 이메일 인증번호 재전송 여부 Observable
     */
    func resendSignUpCode(to email: String) -> Observable<Bool> {
        return Observable.create { observer in
            Task {
                do {
                    let detail = try await Amplify.Auth.resendSignUpCode(for: email)
                    Logger.d("Successed Confirm Code in \(detail.destination), \(String(describing: detail.attributeKey))")
                    observer.onNext(true)
                    observer.onCompleted()
                }
                catch let error as AuthError {
                    Logger.e("resend Email Confirm Code with error \(error)")
                    observer.onError(error)
                }
                catch {
                    Logger.e("Unexpected error \(error)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /**
     * - Description 소셜로그인 함수, 소셜 로그인 이후 서버 프로필 조회 후 사용자가 있는 경우 사용자 정보 반환, 없으면 에러 반환
     * - Parameter view 화면을 띄울 뷰 정보
     * - Parameter socialType 소셜 로그인 정보 {구글, 애플..등}
     * - Returns 프로필 조회 후 사용자 정보
     */
    func socialLogin(view: UIView, socialType: AuthProvider) -> Observable<User> {
        return Observable.create { observable in
            Task {
                do {
                    let signInResult = try await Amplify.Auth.signInWithWebUI(for: socialType, presentationAnchor: view.window!)
                    
                    guard signInResult.isSignedIn else {
                        observable.onError(NetworkError.unknown(-1, "소셜 로그인에 실패하였습니다"))
                        return
                    }
                    
                    // 엑세스, 리프레시 토큰 생성
                    let isSuccessToken = await self.authTokenGenerate()
                    
                    //토큰 생성에 실패한 경우
                    guard isSuccessToken else {
                        observable.onError(NetworkError.unknown(-1, "토큰 생성에 실패하였습니다"))
                        return
                    }
                    
                    // 토큰 생성 후 서버 프로필 조회
                    self.getProfile()
                        .subscribe { user in
                            observable.onNext(user)
                            observable.onCompleted()
                        } onError: { err in
                            observable.onError(err as! NetworkError)
                        }
                        .disposed(by: self.disposeBag)
                    
                }
                catch let error as AuthError {
                    Logger.e("Social Login Failed with error \(error)")
                    
                    guard let cognitoAuthError = error.underlyingError as? AWSCognitoAuthError else {
                        observable.onError(error)
                        return
                    }
                    
                    guard case .userCancelled = cognitoAuthError else {
                        let convertError = self.cognitoAuthErrorHandling(error: cognitoAuthError)
                        observable.onError(convertError)
                        return
                    }
                }
                catch {
                    Logger.e("Social Login Failed with error \(error)")
                    observable.onError(error)
                }
            }
    
            
            return Disposables.create()
        }
    }
    /**
     * - Description 아보카도 프로필 등록 API{활동지역, 닉네임}
     * - Parameter to : 닉네임
     * - Parameter with: 활동지역ID
     * - Returns 등록여부 Observable값 **수정될 수  있음**
     */
    func avocadoSignUp(to nickName: String, with regionId: Int) -> Observable<UserDTO> {
        return singleRequest(.signUp(name: nickName, regionId: regionId), responseType: User.self).asObservable()
    }
    
    /**
     * - Description 사용자 정보 가져오는 API
     * - Warning 404일 경우, 사용자가 없는 경우임
     * - Returns 사용자 정보 모델 Observable값
     */
    func getProfile() -> Observable<User> {
        return Observable.create { observer in
            self.singleRequest<User>(.profile)
                .subscribe { user in
                    observer.onNext(user)
                    observer.onCompleted()
                } onFailure: { err in
                    guard let err = err as? NetworkError else {
                        observer.onError(err)
                        return
                    }
                    
                    switch err {
                    case .pageNotFound:
                        self.logout().subscribe { _ in
                            observer.onError(err)
                        }
                        .disposed(by: self.disposeBag)
                        
                    default:
                        observer.onError(err)
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    /**
     * - Description 활동지역을 가져오는 API
     * - Parameter keyword: 검색 값?
     * - Returns Region의 배열형태 값
     */
    func getRegions(keyword: String) -> Observable<Regions> {
        return singleRequest(.region(searchkeyword: keyword)).asObservable()
    }
    
    /**
     * - Description 프로필 이미지변경 API
     * - Parameter to 닉네임
     * - Parameter with 활동지역 ID
     * - Returns S3 버킷에 업로드할 pre-signed URL
     */
    func changeAvatar(to nickName: String, with regionId: Int) -> Observable<CommonModel.SingleURL> {
        return singleRequest(.changeAvatar(name: nickName, regionId: regionId)).asObservable()
    }
    
    /**
     * - Description authToken{accessToken, refreshToken} 생성 메서드
     * - Returns 토큰 생성 여부
     */
    private func authTokenGenerate() async -> Bool {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            if let cognitTokenResult = (session as? AuthCognitoTokensProvider)?.getCognitoTokens() {
                switch cognitTokenResult {
                case let .success(tokens):
                    Logger.d("token = \(tokens)")
                    // accessToken, refreshToken create
                    let tokenCreate = KeychainUtil.loginTokenCreate(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken)
                    
                    Logger.d("tokens.accessToken = \(tokens.accessToken)")
                    
                    return tokenCreate
                    
                case let .failure(error):
                    Logger.e("token retry failed with error \(error)")
                    return false
                }
            }
            
            return false
        }
        catch {
            Logger.e("token generate error with \(error)")
            return false
        }
    }
    
    /**
     * - Description 코그니토 오류 핸들링
     * - Returns NetworkError
     */
    private func cognitoAuthErrorHandling(error: AWSCognitoAuthError) -> NetworkError {
        switch error {
        case .userNotConfirmed:
            return NetworkError.unknown(-1, "이메일 인증이 되지 않은 사용자입니다")
            
        case .invalidParameter:
            return NetworkError.invaildParameter
            
        default:
            return NetworkError.unknown(-1, error.localizedDescription)
        }
    }
}
