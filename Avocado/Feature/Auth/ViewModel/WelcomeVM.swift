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

final class WelcomeVM:ViewModelType, Stepper {

    //MARK: - RXFlow
    var steps: PublishRelay<Step> = PublishRelay()
    
    // 서비스를 제공하는 인스턴스
    let service: AuthService
    let input: Input
    var disposeBag = DisposeBag()
    
    struct Input {
        let targetViewRelay = BehaviorRelay<UIView>(value: UIView())
        let actionWithGoogleLoginPublish = PublishRelay<Void>()
        let actionWithAppleLoginPublish = PublishRelay<Void>()
    }
    
    struct Output {
        // 로그인 성공 이벤트를 전달하는 인스턴스
        let successEventPublish = PublishRelay<User>()
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<NetworkError>()
    }
    
    // 생성자
    init(service: AuthService) {
        self.service = service
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // FIXME: subscribe 구문 추후 개선 필요
        // googleLogin
        input.actionWithGoogleLoginPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.service.socialLogin(view: input.targetViewRelay.value, socialType: .google).subscribe(onNext: {
                output.successEventPublish.accept($0)
            }, onError: { error in
                output.errEventPublish.accept(error as! NetworkError)
            })
            .disposed(by: disposeBag)
        })
        .disposed(by: disposeBag)
        
        // FIXME: subscribe 구문 추후 개선 필요
        // appleLogin
        input.actionWithAppleLoginPublish.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.service.socialLogin(view: input.targetViewRelay.value, socialType: .apple).subscribe(onNext: {
                    output.successEventPublish.accept($0)
            }, onError: { error in
                output.errEventPublish.accept(error as! NetworkError)
            })
            .disposed(by: disposeBag)
        }
        .disposed(by: disposeBag)
        
        return output
    }
    
    // 이메일 로그인 버튼 클릭 처리
    func handleAvocadoLogin() {
        steps.accept(AuthStep.loginIsRequired)
    }

    // 회원가입 버튼 클릭 처리
    func handleSignup() {
        steps.accept(AuthStep.signUpIsRequired)
    }
}
