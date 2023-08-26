//
//  OtherEmailVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/23.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay

final class OtherEmailVM: ViewModelType, Stepper {
    
    var disposeBag = DisposeBag()
    var service: AuthService
    var input: Input
    let steps: PublishRelay<Step> = PublishRelay()
    
    struct Input {
        let userOldEmailBehavior = BehaviorRelay<String>(value: "")
        let userNewEmailBehavior = BehaviorRelay<String>(value: "")
        let actionOtherEmailCodePublish = PublishRelay<Void>()
        let emailVaildPublish = PublishRelay<Bool>()
    }
    
    struct Output {
        let successOtherEmailCodePublish = PublishRelay<Bool>()
        let errorEventPublish = PublishRelay<AvocadoError>()
    }
    
    init(service: AuthService, oldEmail: String) {
        self.service = service
        input = Input()
        input.userOldEmailBehavior.accept(oldEmail)
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.actionOtherEmailCodePublish
            .flatMap { [weak self] userOtherEmail -> Observable<Bool> in
                // 사용자 이메일 변경
                return self?.service.changeUserEmail(
                    oldEmail: input.userOldEmailBehavior.value,
                    newEmail: input.userNewEmailBehavior.value
                )
                .catch { error in
                    if let error = error as? AvocadoError { output.errorEventPublish.accept(error) }
                    return .empty()
                } ?? .empty()
            }
            .flatMap { [weak self] _ -> Observable<Bool> in
                // 사용자 인증번호 전송
                return self?.service.resendSignUpCode(to: input.userNewEmailBehavior.value)
                    .catch { error in
                        if let error = error as? AvocadoError { output.errorEventPublish.accept(error) }
                        return .empty()
                    } ?? .empty()
            }
            .subscribe { output.successOtherEmailCodePublish.accept($0) }
            .disposed(by: disposeBag)
        
        return output
    }
    
}
