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

struct EmailCheckVM {
    
    
    let service: AuthService
    let disposeBag = DisposeBag()
    
    let successEvent = PublishRelay<Bool>()
    let errEvent = PublishRelay<String>()
    let confirmCode = BehaviorRelay<String>(value: "")
    let userEmail:BehaviorRelay<String> = {
        let signUpEmail = UserDefaults.standard.string(forKey: CommonModel.UserDefault.Auth.signUpEmail) ?? ""
        let userEmailRelay = BehaviorRelay<String>(value: signUpEmail)
        return userEmailRelay
    }()
    
    
    init(service: AuthService) {
        self.service = service
    }
    
    /* 이메일 인증번호 재 전송*/
    func resendSignUpCode() {
        service.resendSignUpCode(to: userEmail.value)
            .subscribe {
                successEvent.accept($0)
            } onError: { err in
                guard let authError = err as? AuthError else {
                    errEvent.accept(err.localizedDescription)
                    return
                }
                
                errEvent.accept(authError.errorDescription)
            }
            .disposed(by: disposeBag)
    }
    
    /* 이메일 인증번호 확인 */
    func confirmSignUpCode() {
        service.confirmSignUp(for: userEmail.value, with: confirmCode.value)
            .subscribe {
                successEvent.accept($0)
                
            } onError: { err in
                guard let authError = err as? AuthError else {
                    errEvent.accept(err.localizedDescription)
                    return
                }
                
                errEvent.accept(authError.errorDescription)
            }
            .disposed(by: disposeBag)
    }
}
