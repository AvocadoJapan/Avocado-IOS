//
//  SettingService.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/06.
//

import Foundation
import RxSwift
import Amplify
import AWSCognitoAuthPlugin

final class SettingService: BaseAPIService<SettingAPI> {
    func socialSync(provider: SocialType, callBack:String) -> Observable<Common.SingleURL> {
        return singleRequest(.auth(provider: provider, callback: callBack)).asObservable()
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
}
