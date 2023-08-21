//
//  LoginVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/26.
//

import Foundation
import RxRelay
import RxSwift
import RxFlow
import Amplify

final class LoginVM: Stepper {
    //MARK: - RXFlow
    var steps: PublishRelay<Step> = PublishRelay()
    
    // 서비스를 제공하는 인스턴스
    private let authService: AuthService
    private let disposeBag = DisposeBag()
    
    // 이메일을 입력받는 인스턴스
    public let emailBehavior = BehaviorRelay<String>(value: "")
    // 비밀번호를 입력받는 인스턴스
    public let passwordBehavior = BehaviorRelay<String>(value: "")
    // 로그인 성공 이벤트를 전달하는 인스턴스
    public let successEventPublish = PublishRelay<User>()
    // 에러 이벤트를 전달하는 인스턴스
    public let errEventPublish = PublishRelay<String>()
    // 이메일과 비밀번호의 유효성을 확인하는 인스턴스
    public var isValidObservable: Observable<Bool> {
        return Observable
            .combineLatest(emailBehavior, passwordBehavior)
            .map { (email, password) in
                return !email.isEmpty && password.count >= 8
            }
    }
    
    // 생성자
    init(service: AuthService) {
        self.authService = service

        successEventPublish
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.steps.accept(AuthStep.loginIsComplete)
            })
            .disposed(by: disposeBag)
    }
    
    // 로그인 요청하는 함수
    func login() {
        authService.login(email: emailBehavior.value, password: passwordBehavior.value)
            .subscribe { _ in
                // 서버 프로필 조회
                self.authService.getProfile()
                    .subscribe(onNext: { user in
                        self.successEventPublish.accept(user)
                    })
                    .disposed(by: self.disposeBag)
            } onError: { err in
                guard let err = err as? AuthError else {
                    self.errEventPublish.accept(err.localizedDescription)
                    return
                }
                self.errEventPublish.accept(err.errorDescription)
            }
            .disposed(by: disposeBag)
        
    }
    

}
