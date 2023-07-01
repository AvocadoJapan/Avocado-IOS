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
                        let session = try await Amplify.Auth.fetchAuthSession()
                        if let cognitTokenResult = (session as? AuthCognitoTokensProvider)?.getCognitoTokens() {
                            switch cognitTokenResult {
                            case let .success(tokens):
                                Logger.d("token = \(tokens)")
                                // accessToken, refreshToken create
                                let tokenCreate = KeychainUtil.loginTokenCreate(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken)
                                
                                if (!tokenCreate) {
                                    observer.onError(NetworkError.unknown(-1, "키체인 생성 실패"))
                                }
                                else {
                                    observer.onNext(true)
                                }
                                
                                observer.onCompleted()
                                
                            case let .failure(error):
                                Logger.e("token retry failed with error \(error)")
                                observer.onError(error)
                            }
                        }
                    }
                    
                    
                    
                }
                catch let error as AuthError {
                    Logger.e("sign in failed \(error)")
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
                    
                case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
                    if let hostedUIError = hostedUIError {
                        Logger.e("HostedUI error \(hostedUIError)")
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                    
                    if let revokeTokenError = revokeTokenError {
                        Logger.e("revokeToken Error \(revokeTokenError)")
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                    
                    if let globalSignOutError = globalSignOutError {
                        Logger.e("globalSignOut Error \(globalSignOutError)")
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                    
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
                                else {
                                    Logger.i("Same Access Token")
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
                    observer.onError(error)
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
     * - Description 소셜로그인
     * - Parameter view 화면을 띄울 뷰 정보
     * - Parameter socialType 소셜 로그인 정보 {구글, 애플..등}
     * - Returns 로그인 여부 Bool 값
     */
    func socialSignInView(view: UIView, socialType: AuthProvider) -> Observable<Bool> {
        return Observable.create { observable in
            Task {
                do {
                    let signInResult = try await Amplify.Auth.signInWithWebUI(for: socialType, presentationAnchor: view.window!)
                    Logger.d("SignIN \(signInResult.isSignedIn)")
                    observable.onNext(signInResult.isSignedIn)
                    observable.onCompleted()
                }
                catch let error as AuthError {
                    Logger.e("Social Login Failed with error \(error)")
                    observable.onError(error)
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
    func avocadoSignUp(to nickName: String, with regionId: Int) -> Observable<Bool> {
        return singleRequest(.signUp(name: nickName, regionId: regionId)).asObservable()
    }
    
    /**
     * - Description 사용자 정보 가져오는 API
     * - Returns 사용자 정보 모델 Observable값
     */
    func getProfile() -> Observable<User> {
        return singleRequest(.profile).asObservable()
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
    func changeAvatar(to nickName: String, with regionId: Int) -> Observable<CommonModel.S3UploadedURL> {
        return singleRequest(.changeAvatar(name: nickName, regionId: regionId)).asObservable()
    }
    
}
