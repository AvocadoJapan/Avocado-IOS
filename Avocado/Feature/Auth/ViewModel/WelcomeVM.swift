//
//  WelcomeVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/28.
//

import Foundation
import UIKit
import RxSwift
import Amplify
import RxRelay

final class WelcomeVM {
    
    let service: AuthService
    let disposeBag = DisposeBag()
    let successEvent = PublishRelay<User>()
    let errEvent = PublishRelay<NetworkError>()
    
    init(service: AuthService) {
        self.service = service
    }
    
    /* 애플 로그인 */
    func socialLoginWithApple(view: UIView) {
        service.socialLogin(view: view, socialType: .apple)
            .subscribe { user in
                self.successEvent.accept(user)
                
            } onError: { err in

                guard let authError = err as? AuthError else {
                    Logger.e(err)
                    self.errEvent.accept(err as! NetworkError)
                    return
                }
                
                self.errEvent.accept(NetworkError.unknown(-1, authError.errorDescription))
            }
            .disposed(by: disposeBag)
    }
    /* 구글 로그인 */
    func socialLoginWithGoogle(view: UIView) {
        service.socialLogin(view: view, socialType: .google)
            .subscribe { user in
                self.successEvent.accept(user)
            } onError: { err in
                
                guard let authError = err as? AuthError else {
                    Logger.e(err)
                    self.errEvent.accept(err as! NetworkError)
                    return
                }
                
                self.errEvent.accept(NetworkError.unknown(-1, authError.errorDescription))
                
            }
            .disposed(by: disposeBag)
    }
}
