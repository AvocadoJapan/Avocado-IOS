//
//  EmailCheckVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/02.
//

import Foundation
import UIKit
import RxSwift
import Amplify
import RxRelay

final class EmailCheckVM {
    
    let service: AuthService
    let disposeBag = DisposeBag()
    
    let successEmailCheckEvent = PublishRelay<Bool>()
    let successEmailResendEvent = PublishRelay<Bool>()
    let successEmailOtherEmailEvent = PublishRelay<Bool>()
    let errEvent = PublishRelay<NetworkError>()
    let confirmCode = BehaviorRelay<String>(value: "")
    let userEmail = BehaviorRelay<String>(value: "")
    let userPassword = BehaviorRelay<String>(value: "")
    
    init(service: AuthService, email: String, password: String) {
        self.service = service
        self.userEmail.accept(email)
        self.userPassword.accept(password)
    }
    
    /* 이메일 인증번호 재 전송*/
    func resendSignUpCode() {
        service.resendSignUpCode(to: userEmail.value)
            .subscribe {
                self.successEmailResendEvent.accept($0)
            } onError: { err in
                guard let authError = err as? AuthError else {
                    self.errEvent.accept(NetworkError.unknown(-1, err.localizedDescription))
                    return
                }
                
                self.errEvent.accept(NetworkError.unknown(-1, authError.errorDescription))
            }
            .disposed(by: disposeBag)
    }
    
    /* 이메일 인증번호 확인 */
    func confirmSignUpCode() {
        service.confirmSignUp(for: userEmail.value, with: confirmCode.value)
            .subscribe { isSuccess in
                guard isSuccess else {
                    self.errEvent.accept(NetworkError.unknown(-1, "인증번호 실패"))
                    return
                }
                
                // 인증번호가 정상 인경우, 코그니토 로그인 로직 실행
                self.service.login(email: self.userEmail.value, password: self.userPassword.value)
                    .subscribe(onNext: { isSuccess in
                        if isSuccess {
                            self.successEmailCheckEvent.accept(true)
                        }
                        else {
                            self.errEvent.accept(NetworkError.unknown(-1, "로그인에 실패하였습니다"))
                        }
                        
                    }) { err in
                        self.errEvent.accept(NetworkError.unknown(-1, err.localizedDescription))
                    }
                    .disposed(by: self.disposeBag)
                
            } onError: { err in
                guard let authError = err as? AuthError else {
                    self.errEvent.accept(NetworkError.unknown(-1, err.localizedDescription))
                    return
                }
                
                self.errEvent.accept(NetworkError.unknown(-1, authError.errorDescription))
            }
            .disposed(by: disposeBag)
    }
    
    /* 다른 이메일로 인증 */
    func otherEmailSignUp() {
        service.deleteAccount()
            .subscribe {
                self.successEmailOtherEmailEvent.accept($0)
            } onError: { err in
                guard let authError = err as? AuthError else {
                    self.errEvent.accept(NetworkError.unknown(-1, err.localizedDescription))
                    return
                }
                
                self.errEvent.accept(NetworkError.unknown(-1, authError.errorDescription))
            }
            .disposed(by: disposeBag)

    }
}
