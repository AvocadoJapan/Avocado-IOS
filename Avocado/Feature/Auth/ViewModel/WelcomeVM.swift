//
//  WelcomeVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/28.
//

import Foundation
import UIKit
import RxSwift
import RxFlow
import Amplify
import RxRelay

final class WelcomeVM: Stepper {
    
    //MARK: - RXFlow
    var steps: PublishRelay<Step> = PublishRelay()
    
    // 서비스를 제공하는 인스턴스
    let authService: AuthService
    let disposeBag = DisposeBag()
    // 로그인 성공 이벤트를 전달하는 인스턴스
    let successEventPublish = PublishRelay<User>()
    // 에러 이벤트를 전달하는 인스턴스
    let errEventPublish = PublishRelay<NetworkError>()
    
    // 생성자
    init(service: AuthService) {
        self.authService = service
    }
    
    // 애플 로그인 함수
    func socialLoginWithApple(view: UIView) {
        authService.socialLogin(view: view, socialType: .apple)
            .subscribe { user in
                self.successEventPublish.accept(user)
            } onError: { err in
                guard let authError = err as? AuthError else {
                    Logger.e(err)
                    self.errEventPublish.accept(err as! NetworkError)
                    return
                }
                self.errEventPublish.accept(NetworkError.unknown(-1, authError.errorDescription))
            }
            .disposed(by: disposeBag)
    }
    
    // 구글 로그인 함수
    func socialLoginWithGoogle(view: UIView) {
        authService.socialLogin(view: view, socialType: .google)
            .subscribe { user in
                self.successEventPublish.accept(user)
            } onError: { err in
                guard let authError = err as? AuthError else {
                    Logger.e(err)
                    self.errEventPublish.accept(err as! NetworkError)
                    return
                }
                self.errEventPublish.accept(NetworkError.unknown(-1, authError.errorDescription))
            }
            .disposed(by: disposeBag)
    }
    
    // 이메일 로그인 버튼 클릭 처리
    func handleAvocadoLogin() {
        steps.accept(AuthStep.loginIsRequired)
    }

    // 회원가입 버튼 클릭 처리
    func handleSignup() {
        steps.accept(AuthStep.loginIsRequired)
    }
}
