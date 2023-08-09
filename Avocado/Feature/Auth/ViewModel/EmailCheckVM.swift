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
        let errEventPublish = PublishRelay<NetworkError>()
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
        input.actionResendSignUpCodeRelay.flatMap { [weak self] _ in
            // 순환 참조가 일어날 경우를 대비한 guard문, 만약 순환참조가 일어났을 경우 에러 리턴
            guard let self = self else { throw NetworkError.unknown(-1, "유효하지 않은 화면") }
            // 인증번호 재전송 로직 호출
            return self.service.resendSignUpCode(to: input.userEmailRelay.value)
        }
        .subscribe {
            output.successEmailResendPublish.accept($0)
        } onError: { err in
            guard let authError = err as? AuthError else {
                output.errEventPublish.accept(NetworkError.unknown(-1, err.localizedDescription))
                return
            }
            output.errEventPublish.accept(NetworkError.unknown(-1, authError.errorDescription))
        }
        .disposed(by: disposeBag)
        
        
        // 인증번호 유효성 체크
        input.actionConfirmSignUpCodeRelay
            .flatMap { [weak self] _  in
                guard let self = self else { throw NetworkError.unknown(-1, "유효하지 않은 화면") }
                return self.service.confirmSignUp(for: input.userEmailRelay.value, with: input.confirmCodeRelay.value)
            }
            .flatMap { [weak self] isSuccess in
                guard let self = self else { throw NetworkError.unknown(-1, "유효하지 않은 화면") }
                guard isSuccess else { throw NetworkError.unknown(-4, "인증번호가 일치하지 않음") }
                return self.service.login(email: input.userEmailRelay.value, password: input.userPasswordRelay.value)
            }
            .subscribe(onNext: { isSuccess in
                if isSuccess {
                    output.successEmailCheckPublish.accept(true)
                } else {
                    output.errEventPublish.accept(NetworkError.unknown(-1, "로그인에 실패하였습니다"))
                }
            }, onError: { err in
                output.errEventPublish.accept(NetworkError.unknown(-1, err.localizedDescription))
            })
            .disposed(by: disposeBag)
        
        
        // 다른 이메일 인증
        input.actionOtherEmailSignUpRelay
            .flatMap { [weak self] _  in
                guard let self = self else { throw NetworkError.unknown(-1, "유효하지 않은 화면") }
                return self.service.deleteAccount()
            }
            .subscribe {
                output.successDeleteTepmAccount.accept($0)
            } onError: { err in
                guard let authError = err as? AuthError else {
                    output.errEventPublish.accept(NetworkError.unknown(-1, err.localizedDescription))
                    return
                }
                
                output.errEventPublish.accept(NetworkError.unknown(-1, authError.errorDescription))
            }
            .disposed(by: disposeBag)
        
        return output
    }
}


///* 이메일 인증번호 재 전송*/
//    func resendSignUpCode() {
//        authService.resendSignUpCode(to: userEmailRelay.value)
//            .subscribe {
//                self.successEmailResendPublish.accept($0)
//            } onError: { err in
//                guard let authError = err as? AuthError else {
//                    self.errEventPublish.accept(NetworkError.unknown(-1, err.localizedDescription))
//                    return
//                }
//                
//                self.errEventPublish.accept(NetworkError.unknown(-1, authError.errorDescription))
//            }
//            .disposed(by: disposeBag)
//    }
//    
//    /* 이메일 인증번호 확인 */
//    func confirmSignUpCode() {
//        authService.confirmSignUp(for: userEmailRelay.value, with: confirmCodeRelay.value)
//            .subscribe { isSuccess in
//                guard isSuccess else {
//                    self.errEventPublish.accept(NetworkError.unknown(-1, "인증번호 실패"))
//                    return
//                }
//                
//                // 인증번호가 정상 인경우, 코그니토 로그인 로직 실행
//                self.authService.login(email: self.userEmailRelay.value, password: self.userPasswordRelay.value)
//                    .subscribe(onNext: { isSuccess in
//                        if isSuccess {
//                            self.successEmailCheckPublish.accept(true)
//                        }
//                        else {
//                            self.errEventPublish.accept(NetworkError.unknown(-1, "로그인에 실패하였습니다"))
//                        }
//                        
//                    }) { err in
//                        self.errEventPublish.accept(NetworkError.unknown(-1, err.localizedDescription))
//                    }
//                    .disposed(by: self.disposeBag)
//                
//            } onError: { err in
//                guard let authError = err as? AuthError else {
//                    self.errEventPublish.accept(NetworkError.unknown(-1, err.localizedDescription))
//                    return
//                }
//                
//                self.errEventPublish.accept(NetworkError.unknown(-1, authError.errorDescription))
//            }
//            .disposed(by: disposeBag)
//    }
//    
//    /* 다른 이메일로 인증 */
//    func otherEmailSignUp() {
//        authService.deleteAccount()
//            .subscribe {
//                self.successEmailOtherEmailPublish.accept($0)
//            } onError: { err in
//                guard let authError = err as? AuthError else {
//                    self.errEventPublish.accept(NetworkError.unknown(-1, err.localizedDescription))
//                    return
//                }
//                
//                self.errEventPublish.accept(NetworkError.unknown(-1, authError.errorDescription))
//            }
//            .disposed(by: disposeBag)
//
//    }
