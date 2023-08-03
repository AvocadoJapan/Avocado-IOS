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
    
    let authService: AuthService
    let disposeBag = DisposeBag()
    
    let successEmailCheckPublish = PublishRelay<Bool>()
    let successEmailResendPublish = PublishRelay<Bool>()
    let successEmailOtherEmailPublish = PublishRelay<Bool>()
    let errEventPublish = PublishRelay<NetworkError>()
    let confirmCodeRelay = BehaviorRelay<String>(value: "")
    let userEmailRelay = BehaviorRelay<String>(value: "")
    let userPasswordRelay = BehaviorRelay<String>(value: "")
    
    init(service: AuthService, email: String, password: String) {
        self.authService = service
        self.userEmailRelay.accept(email)
        self.userPasswordRelay.accept(password)
        
        bindRxFlow()
    }
    
    /* 이메일 인증번호 재 전송*/
    func resendSignUpCode() {
        authService.resendSignUpCode(to: userEmailRelay.value)
            .subscribe {
                self.successEmailResendPublish.accept($0)
            } onError: { err in
                guard let authError = err as? AuthError else {
                    self.errEventPublish.accept(NetworkError.unknown(-1, err.localizedDescription))
                    return
                }
                
                self.errEventPublish.accept(NetworkError.unknown(-1, authError.errorDescription))
            }
            .disposed(by: disposeBag)
    }
    
    /* 이메일 인증번호 확인 */
    func confirmSignUpCode() {
        authService.confirmSignUp(for: userEmailRelay.value, with: confirmCodeRelay.value)
            .subscribe { isSuccess in
                guard isSuccess else {
                    self.errEventPublish.accept(NetworkError.unknown(-1, "인증번호 실패"))
                    return
                }
                
                // 인증번호가 정상 인경우, 코그니토 로그인 로직 실행
                self.authService.login(email: self.userEmailRelay.value, password: self.userPasswordRelay.value)
                    .subscribe(onNext: { isSuccess in
                        if isSuccess {
                            self.successEmailCheckPublish.accept(true)
                        }
                        else {
                            self.errEventPublish.accept(NetworkError.unknown(-1, "로그인에 실패하였습니다"))
                        }
                        
                    }) { err in
                        self.errEventPublish.accept(NetworkError.unknown(-1, err.localizedDescription))
                    }
                    .disposed(by: self.disposeBag)
                
            } onError: { err in
                guard let authError = err as? AuthError else {
                    self.errEventPublish.accept(NetworkError.unknown(-1, err.localizedDescription))
                    return
                }
                
                self.errEventPublish.accept(NetworkError.unknown(-1, authError.errorDescription))
            }
            .disposed(by: disposeBag)
    }
    
    /* 다른 이메일로 인증 */
    func otherEmailSignUp() {
        authService.deleteAccount()
            .subscribe {
                self.successEmailOtherEmailPublish.accept($0)
            } onError: { err in
                guard let authError = err as? AuthError else {
                    self.errEventPublish.accept(NetworkError.unknown(-1, err.localizedDescription))
                    return
                }
                
                self.errEventPublish.accept(NetworkError.unknown(-1, authError.errorDescription))
            }
            .disposed(by: disposeBag)

    }
    
    func bindRxFlow() {
//        successEmailCheckPublish
//            .asSignal()
//            .emit(onNext: { [weak self] isSuccess in
//                let authService = AuthService()
//                let regionVM = RegionSettingVM(service: authService)
//                let regionVC = RegionSettingVC(viewModel: regionVM)
//                let navigaitonVC = regionVC.makeBaseNavigationController()
//                
//                self?.present(navigaitonVC, animated: true)
//            })
//            .disposed(by: disposeBag)
    }
}
