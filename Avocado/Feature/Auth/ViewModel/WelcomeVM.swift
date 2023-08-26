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
        
        // googleLogin
        input.actionWithGoogleLoginPublish
            .flatMap { [weak self] _ -> Observable<User> in
                return self?.service.socialLogin(
                    view: input.targetViewRelay.value,
                    socialType: .google
                )
                .catch { error in
                    if let error = error as? NetworkError { output.errEventPublish.accept(error)}
                    return .empty()
                } ?? .empty()
            }
            .subscribe { output.successEventPublish.accept($0) }
            .disposed(by: disposeBag)
        
        // appleLogin
        input.actionWithAppleLoginPublish
            .flatMap { [weak self] _ -> Observable<User> in
                return self?.service.socialLogin(
                    view: input.targetViewRelay.value,
                    socialType: .apple
                )
                .catch { error in
                    if let error = error as? NetworkError { output.errEventPublish.accept(error)}
                    return .empty()
                } ?? .empty()
            }
            .subscribe { output.successEventPublish.accept($0) }
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
