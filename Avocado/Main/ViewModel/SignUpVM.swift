//
//  SignUpVM.swift
//  Avocado
//
//  Created by FOCUSONE Inc. on 2023/06/26.
//

import Foundation
import RxSwift
import RxRelay
import Amplify

final class SignUpVM {
 
    private let service: AuthService
    private let disposeBag = DisposeBag()
    
    public let emailObserver = BehaviorRelay<String>(value: "")
    public let passwordObserver = BehaviorRelay<String>(value: "")
    public let passwordCheckObserver = BehaviorRelay<String>(value: "")
    public let errEvent = PublishRelay<String>()
    public let successEvent = PublishRelay<Bool>()
    public var isVaild: Observable<Bool> {
    
        return Observable
            .combineLatest(emailObserver, passwordObserver, passwordCheckObserver)
            .map { (email, password, passwordCheck) in
                return !email.isEmpty &&
                !password.isEmpty &&
                !passwordCheck.isEmpty &&
                (password == passwordCheck)
            }
    }
    
    public func signUp() {
        service.signUp(email: emailObserver.value, password: passwordObserver.value)
            .subscribe {
                
                UserDefaults.standard.setValue($0, forKey: CommonModel.UserDefault.Auth.signUpSuccess)
                UserDefaults.standard.synchronize()
                
                self.successEvent.accept($0)
                
            } onError: { err in
                guard let err = err as? AuthError else {
                    self.errEvent.accept(err.localizedDescription)
                    return
                }
                
                self.errEvent.accept(err.errorDescription)
            }
            .disposed(by: disposeBag)
    }
    
    public func validatePasswordMatch() -> String {
        
        let password = self.passwordObserver.value
        let passwordCheck = self.passwordCheckObserver.value
        
        return password != passwordCheck ? "비밀번호가 일치하지 않습니다." : ""
    }
    
    init(service: AuthService) {
        self.service = service
    }
}
