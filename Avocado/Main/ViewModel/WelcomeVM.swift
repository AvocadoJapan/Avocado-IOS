//
//  WelcomeVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/28.
//

import Foundation
import UIKit
import RxSwift

struct WelcomeVM {
    
    let service: AuthService
    let disposeBag = DisposeBag()
    
    init(service: AuthService) {
        self.service = service
    }
    
    /* 애플 로그인 */
    func socialLoginWithApple(view: UIView) {
        service.socialSignInView(view: view, socialType: .apple)
            .subscribe { signIn in
                // doing..
            } onError: { err in
                Logger.e(err)
            }
            .disposed(by: disposeBag)
    }
    /* 구글 로그인 */
    func socialLoginWithGoogle(view: UIView) {
        service.socialSignInView(view: view, socialType: .google)
            .subscribe { signIn in
                // doing..
            } onError: { err in
                Logger.e(err)
            }
            .disposed(by: disposeBag)
    }
}
