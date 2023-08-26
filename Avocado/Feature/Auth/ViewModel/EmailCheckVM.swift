//
//  EmailCheckVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/02.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay
import RxRelay
import Amplify

final class EmailCheckVM: ViewModelType, Stepper  {
    
    // RxFlow steps
    let steps: PublishRelay<Step> = PublishRelay()
    var disposeBag = DisposeBag()
    
    // 서비스를 제공하는 인스턴스
    let service: AuthService
   
    private(set) var input: Input
//    private(set) var output: Output
    
    struct Input {
        // 이메일을 입력받는 인스턴스
        let confirmCodeRelay = BehaviorRelay<String>(value: "")
        // 이메일을 입력받는 인스턴스
        let userEmailRelay = BehaviorRelay<String>(value: "")
        // 이메일을 입력받는 인스턴스
        let userPasswordRelay = BehaviorRelay<String>(value: "")
        // 인증번호 재전송 액션
        let actionResendSignUpCodeRelay = PublishRelay<Void>()
        // 인증번호 유효성 확인 액션
        let actionConfirmSignUpCodeRelay = PublishRelay<Void>()
        // 인증번호 유효성 확인 액션
        let actionOtherEmailSignUpRelay = PublishRelay<Void>()
    }
    
    struct Output {
        // 유저에게 보낸 인증번호를 일치하게 입력했는지 여부
        let successEmailCheckPublish = PublishRelay<Bool>()
        // 성공적으로 이메일을 제전송했는지 여부
        let successEmailResendPublish = PublishRelay<Bool>()
        // 인증되지 않은 계정탈퇴 성공여부
        let successDeleteTepmAccount = PublishRelay<Bool>()
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<AvocadoError>()
    }
    
    init(service: AuthService, email: String, password: String) {
        input = Input()
        
        self.service = service

        input.userEmailRelay.accept(email)
        input.userPasswordRelay.accept(password)
        
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // 인증번호 재전송
        input.actionResendSignUpCodeRelay
            .flatMap { [weak self] _ -> Observable<Bool> in
                // 인증번호 재전송 로직 호출
                return self?.service.resendSignUpCode(to: input.userEmailRelay.value)
                    .catch { error in
                        if let error = error as? AvocadoError { output.errEventPublish.accept(error) }
                        return .empty()
                    } ?? .empty()
            }
            .subscribe { output.successEmailResendPublish.accept($0) }
            .disposed(by: disposeBag)
        
        
        // 인증번호 유효성 체크
        input.actionConfirmSignUpCodeRelay
            .flatMap { [weak self] _ -> Observable<Bool> in
                return self?.service.confirmSignUp(for: input.userEmailRelay.value, with: input.confirmCodeRelay.value)
                    .catch { error in
                        if let error = error as? AvocadoError { output.errEventPublish.accept(error) }
                        return .empty()
                    } ?? .empty()
            }
            .flatMap { [weak self] isSuccess -> Observable<Bool> in
                
                guard isSuccess else {
                    output.errEventPublish.accept(UserAuthError.emailConfirmCodeMisMatch)
                    return .empty()
                }
                
                // 사용자 로그인 진행
                return self?.service.login(
                    email: input.userEmailRelay.value,
                    password: input.userPasswordRelay.value
                )
                .catch { error in
                    if let error = error as? AvocadoError { output.errEventPublish.accept(error) }
                    return .empty()
                } ?? .empty()
            }
            .subscribe(onNext: { isSuccess in
                if isSuccess {
                    output.successEmailCheckPublish.accept(true)
                }
                else {
                    output.errEventPublish.accept(UserAuthError.userLoginFailed)
                }
            })
            .disposed(by: disposeBag)
        
        
        // 다른 이메일 인증
        input.actionOtherEmailSignUpRelay
            .subscribe { _ in output.successDeleteTepmAccount.accept(true) }
            .disposed(by: disposeBag)
        
        return output
    }
}
