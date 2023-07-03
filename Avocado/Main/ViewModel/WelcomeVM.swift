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

struct WelcomeVM {
    
    let service: AuthService
    let disposeBag = DisposeBag()
    let successEvent = PublishRelay<Bool>()
    let errEvent = PublishRelay<String>()
    
    init(service: AuthService) {
        self.service = service
    }
    
    /* 애플 로그인 */
    func socialLoginWithApple(view: UIView) {
        service.socialSignInView(view: view, socialType: .apple)
            .subscribe { signIn in
                successEvent.accept(signIn)
            } onError: { err in

                guard let authError = err as? AuthError else {
                    Logger.e(err)
                    errEvent.accept(err.localizedDescription)
                    return
                }
                
                errEvent.accept(authError.errorDescription)
            }
            .disposed(by: disposeBag)
    }
    /* 구글 로그인 */
    func socialLoginWithGoogle(view: UIView) {
        service.socialSignInView(view: view, socialType: .google)
            .subscribe { signIn in
                successEvent.accept(signIn)
            } onError: { err in

                guard let authError = err as? AuthError else {
                    Logger.e(err)
                    errEvent.accept(err.localizedDescription)
                    return
                }
                
                errEvent.accept(authError.errorDescription)
            }
            .disposed(by: disposeBag)
    }
}
