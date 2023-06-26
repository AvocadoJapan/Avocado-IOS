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

/**
 * - Description 인증관련 API
 */
final class AuthService {
 
    init () {
        
    }
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
                    observer.onNext(loginResult.isSignedIn)
                    observer.onCompleted()
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
                    observer.onNext(true)
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
                    observer.onNext(true)
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
                        KeychainUtil.loginTokenCreate(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken)
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
    
    
}
