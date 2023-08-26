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
import AWSCognitoIdentityProvider
import ClientRuntime
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
                    
                    // 이메일 인증
                    if case let .confirmUser(deliveryDetails, _, userid) = signUpResult.nextStep {
                        Logger.d("Delivery details \(String(describing: deliveryDetails)) for userId \(String(describing: userid))")
                        /*
                         이메일 인증 값 설정 { 해당 값은 이메일 인증 시 값이 삭제 될 예정 }
                         이메일 인증 도중 앱을 종료한 경우 해당 값으로 체크 {다른 이메일로 로그인을 할 수 있기 때문에 userId로 저장 }
                         */
                        UserDefaults.standard.set(userid, forKey: UserDefaultsKey.Auth.notConfirmedUserID)
                    }
                    
                    // 회원가입에 성공한 경우
                    observer.onNext(true)
                    observer.onCompleted()
                    
                }
                catch let error as AuthError {
                    Logger.e("sign in failed \(error)")
                    let convertError = self.cognitoAuthErrorHandling(error: error)
                    observer.onError(convertError)
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
        return Observable.create { [weak self] observer in
            
            guard let self = self else {
                return Disposables.create()
            }
            
            Task {
                do {
                    let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(for: email, confirmationCode: confirmationCode)
                    Logger.d("Confirm signUp result Complted \(confirmSignUpResult.isSignUpComplete)")
                    // 사용자가 인증에 성공한 경우 인증이메일 키 삭제
                    if (confirmSignUpResult.isSignUpComplete) {
                        
                        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.Auth.notConfirmedUserID)
                    }
                    
                    observer.onNext(confirmSignUpResult.isSignUpComplete)
                    observer.onCompleted()
                }
                catch let error as AuthError {
                    Logger.e("An error occurred while confirming sign up \(error)")
                    let convertError = self.cognitoAuthErrorHandling(error: error)
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
                        // 엑세스, 리프레시 토큰 생성
                        let isSuccessToken = await self.authTokenGenerate()
                        
                        //토큰 생성에 실패한 경우
                        guard isSuccessToken else {
                            observer.onError(NetworkError.unknown(-1, "액세스 토큰 생성 또는 갱신에 실패하였습니다"))
                            return
                        }
                        
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                }
                catch let error as AuthError {
                    Logger.e("sign in failed \(error)")
                    let convertError = self.cognitoAuthErrorHandling(error: error)
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
     * - Description 사용자 로그아웃 함수
     * - Returns 로그아웃 성공여부
     */
    @discardableResult
    private func logout() async throws -> Bool {
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult else {
            Logger.e("SignOut Faild")
            throw NetworkError.unknown(-1, "로그아웃에 실패했습니다")
        }
        
        switch signOutResult {
        case .complete:
            Logger.d("signOut Success")
            // accessToken, refreshToken delete
            let isDeleted = KeychainUtil.loginTokenDelete()
            if !isDeleted {
                throw NetworkError.unknown(-1, "토큰 삭제에 실패하였습니다")
            }
            else {
                return true
            }
            
        case let .partial(revokeTokenError, globalSignOutError, _):
            // accessToken, refreshToken delete
            KeychainUtil.loginTokenDelete()
            
            // 각종 에러 처리
            if let revokeTokenError = revokeTokenError {
                Logger.e("revokeToken Error \(revokeTokenError)")
                throw NetworkError.unknown(-1, revokeTokenError.error.errorDescription)
            }
            
            if let globalSignOutError = globalSignOutError {
                Logger.e("globalSignOut Error \(globalSignOutError)")
                throw NetworkError.unknown(-1, globalSignOutError.error.errorDescription)
            }
            
            //에러가 없을 경우
            Logger.d("signOut Success")
            return true
            
        case let .failed(error):
            Logger.e("Sign Out failed with \(error)")
            throw NetworkError.unknown(-1, error.errorDescription)
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
                    let convertError = self.cognitoAuthErrorHandling(error: error)
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
                    let convertError = self.cognitoAuthErrorHandling(error: error)
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
                    let convertError = self.cognitoAuthErrorHandling(error: error)
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
                    let convertError = self.cognitoAuthErrorHandling(error: error)
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
                        let convertError = self.cognitoAuthErrorHandling(error: error)
                        observer.onError(convertError)
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
        
        return Observable.create { [weak self] observer in
            
            guard let self = self else { return Disposables.create() }
            
            let task = Task {
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
                                observer.onCompleted()
                                
                            case let .failure(error):
                                // 코그니토 로그인은 하였으나 오류로 인해 로그인을 하지 못한 경우
                                Logger.e("token retry failed with error \(error.errorDescription)")
                                
                                // 로그아웃 후 에러 리턴
                                do {
                                    try await self.logout()
                                    let convertError = self.cognitoAuthErrorHandling(error: error)
                                    observer.onError(convertError) //로그아웃 성공 후 이전 에러를 그대로 리턴
                                }
                                catch let networkerror as NetworkError {
                                    observer.onError(networkerror) // 로그아웃에 실패한 경우 에러 리턴
                                }
                            }
                        }
                    }
                    else {
                        // 코그니토 로그인이 되지않은 경우
                        Logger.e("User Signed Failed !!")
                        observer.onNext(false)
                    }
                }
                catch let error as AuthError {
                    Logger.e("Fetch session faild with error \(error)")
                    let convertError = self.cognitoAuthErrorHandling(error: error)
                    observer.onError(convertError)
                }
                catch {
                    Logger.e("Unexpected error: \(error)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
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
                    let convertError = self.cognitoAuthErrorHandling(error: error)
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
                        observable.onError(UserAuthError.createTokenFailed)
                        return
                    }
                    
                    // 토큰 생성 후 서버 프로필 조회
                    // 이때 404 발생 시 사용자가 없는 것으로 판단하여 코그니토 로그아웃 실행
                    self.getProfile()
                        .catch { [unowned self] error in
                            let networkError = error as! NetworkError
                            if case .pageNotFound = networkError {
                                Task {
                                    do {
                                        try await self.logout()
                                        observable.onError(networkError)
                                    }
                                    catch {
                                        observable.onError(networkError)
                                    }
                                }
                            }
                            
                            return .empty()
                        }
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
                        let convertError = self.cognitoAuthErrorHandling(error: error)
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
     * - Returns 유저 정보
     */
    func avocadoSignUp(to nickName: String, with regionId: String) -> Observable<UserDTO> {
        return singleRequest(.signUp(name: nickName, regionId: regionId), responseType: User.self).asObservable()
    }
    
    /**
     * - Description 사용자 정보 가져오는 API
     * - Warning 404일 경우, 사용자가 없는 경우임
     * - Returns 사용자 정보 모델 Observable값
     */
    func getProfile() -> Observable<User> {
        return singleRequest<User>(.profile).asObservable()
    }
    
    /**
     * - Description 활동지역을 가져오는 API
     * - Parameter keyword: 검색 값?
     * - Returns Region의 배열형태 값
     */
    func getRegions(keyword: String, depth: Int) -> Observable<Regions> {
        return singleRequest(.region(searchkeyword: keyword, depth: depth)).asObservable()
    }
    
    /**
     * - Description 프로필 이미지변경 API
     * - Parameter to 이미지 ID
     * - Returns 아바타 정보
     */
    func changeAvatar(to imageId: String) -> Observable<Avatar> {
        return singleRequest(.changeAvatar(imageId: imageId)).asObservable()
    }
    /**
     * - Description 이미지 presignedURL 요청 API
     * - Parameter type 이미지 타입 ex image/jpeg, image/png... {앱에서는 jpeg 고정으로 사용 (용량이 가장 작기 때문)}
     * - Parameter size 파일 사이즈
     * - Returns S3 버킷에 올릴 데이터 정보
     */
    func uploadAvatar(type: String, size: Int64) -> Observable<Common.PresignedURLData> {
        return singleRequest(.uploadAvatar(type: type, size: size)).asObservable()
    }
    /**
     * - Description 관리자 권한으로 사용자 이메일 변경 함수
     * - Parameter oldEmail: 변경 전 이메일
     * - Parameter newEmail:변경 후 이메일
     * - Warning 해당 기능을 이용할 경우 `Xcode` > `Edit Scheme` > `Arguments`에 아래 내용을 기입 하여야 함
     * ```
     * `AWS_REGION`: AWS 리전 정보
     * `AWS_ACCESS_KEY_ID`: AWS 액세스 키 정보
     * `AWS_SECRET_ACCESS_KEY`: AWS 시크릿 키 정보
     * ```
     */
    func changeUserEmail(oldEmail: String, newEmail: String) -> Observable<Bool> {
        
        return Observable.create { [weak self] observer in
            
            guard let self = self else {
                return Disposables.create()
            }
            
            Task {
                do {
                    
                    let client = self.cognitoIdentityProviderClient()
                    
                    // 사용자 정보를 관리자 권한으로 업데이트
                    // email: 변경 할 이메일
                    // email_verified: 이메일 확인 여부
                    let _ = try await client.adminUpdateUserAttributes(input: AdminUpdateUserAttributesInput(
                        userAttributes: [
                            CognitoIdentityProviderClientTypes.AttributeType(name: "email", value: newEmail),
                            CognitoIdentityProviderClientTypes.AttributeType(name: "email_verified", value: "true"),
                        ],
                        userPoolId: "ap-northeast-2_k1tD9KrYe",
                        username: oldEmail)
                    )
                    
                    observer.onNext(true)
                    observer.onCompleted()
                    
                }
                catch let error as SdkError<AdminUpdateUserAttributesOutputError> {
                    
                    if case let .client(clientError, _) = error,
                       case let .retryError(serviceError) = clientError,
                       case let .service(authError, _) = serviceError as? SdkError<AdminUpdateUserAttributesOutputError>{
                        
                        switch authError {
                        case .aliasExistsException(let exception):
                            Logger.e(exception.message!)
                            observer.onError(UserAuthError.userEmailExists)
                            
                        case .invalidParameterException:
                            observer.onError(UserAuthError.emailRoleMisMatch)
                            
                        default:
                            Logger.e(error.localizedDescription)
                            observer.onError(UserAuthError.unknown(message: error.localizedDescription))
                        }
                    }
                    else {
                        Logger.e(error.localizedDescription)
                        observer.onError(UserAuthError.unknown(message: error.localizedDescription))
                    }
                }
            }
            
            
            return Disposables.create()
        }
    }
    
    /**
     * - description 관리자 권한으로 사용자 삭제 함수
     * - parameter userId: 사용자 아이디
     * - returns 반환값이 없는 옵저버블 반환
     * - Warning 해당 기능을 이용할 경우 `Xcode` > `Edit Scheme` > `Arguments`에 아래 내용을 기입 하여야 함
     * ```
     * `AWS_REGION`: AWS 리전 정보
     * `AWS_ACCESS_KEY_ID`: AWS 액세스 키 정보
     * `AWS_SECRET_ACCESS_KEY`: AWS 시크릿 키 정보
     * ```
     */
    func adminDeleteUserAccount(userId: String) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            
            let task = Task {
                do {
                    
                    // 사용자 삭제
                    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.Auth.notConfirmedUserID)
                    
                    let client = self.cognitoIdentityProviderClient()
                    let _ = try await client.adminDeleteUser(input: AdminDeleteUserInput(userPoolId: "ap-northeast-2_k1tD9KrYe",
                                                                               username: userId))
                    Logger.d("SUCCESS USER DELETE")
                    observer.onNext(())
                    observer.onCompleted()
                }
                catch let error as SdkError<AdminDeleteUserOutputError> {
                    
                    Logger.e(error)
                    
                    if case let .client(clientError, _) = error,
                       case let .retryError(serviceError) = clientError,
                       case let .service(authError, _) = serviceError as? SdkError<AdminDeleteUserOutputError>{
                        
                        switch authError {
                        case .userNotFoundException:
                            observer.onError(UserAuthError.userNotFound)
                        default:
                            observer.onError(UserAuthError.unknown(message: authError.localizedDescription))
                        }
                    }
                    else {
                        Logger.e(error.localizedDescription)
                        observer.onError(UserAuthError.unknown(message: error.localizedDescription))
                    }
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
            
        }
    }
    
    /**
     * - Description Amplify에서 지원하지 않는 함수를 사용하기 위한 Client 사용자 get 함수
     * - Returns 함수 사용에 필요한 객체
     */
    private func cognitoIdentityProviderClient() -> CognitoIdentityProviderClient {
        let plugin = try? Amplify.Auth.getPlugin(for: "awsCognitoAuthPlugin") as? AWSCognitoAuthPlugin
        
        if case .userPool(let userPoolClient) = plugin?.getEscapeHatch() {
            return userPoolClient
        }
        else {
            fatalError("No user pool configuration found")
        }
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
                    Logger.d("tokens.accessToken = \(tokens.accessToken)")
                    
                    // 토큰이 없는 경우 생성
                    guard let readToken = KeychainUtil.loginAccessTokenRead() else {
                        // 엑세스, 리프레시 토큰 생성
                        let tokenCreate = KeychainUtil.loginTokenCreate(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken)
                        return tokenCreate
                    }
                    
                    // 이미 토큰이 있다면 갱신
                    if (readToken != tokens.accessToken) {
                        let tokenUpdate = KeychainUtil.loginAccessTokenUpdate(token: tokens.accessToken)
                        return tokenUpdate
                    }
                    
                    return true
                    
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
    private func cognitoAuthErrorHandling(error: AuthError) -> UserAuthError {

        guard let cognitoError = error.underlyingError as? AWSCognitoAuthError else {
            return UserAuthError.unknown(message: error.errorDescription)
        }
        
        switch cognitoError {
        case .usernameExists:
            return UserAuthError.userEmailExists
        case .userNotConfirmed:
            return UserAuthError.emailNotConfirmed
        case .codeExpired:
            return UserAuthError.emailConfirmCodeExpired
        case .codeMismatch:
            return UserAuthError.emailConfirmCodeMisMatch
        default:
            return UserAuthError.unknown(message: error.localizedDescription)
        }
    }
}
