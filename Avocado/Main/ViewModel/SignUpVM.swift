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

struct SignUpVM {
 
    private let service: AuthService
    private let disposeBag = DisposeBag()
    
    public let emailObserver = BehaviorRelay<String>(value: "")
    public let passwordObserver = BehaviorRelay<String>(value: "")
    public let errEvent = PublishRelay<String>()
    public let successEvent = PublishRelay<Bool>()
    public var isVaild: Observable<Bool> {
        return Observable
            .combineLatest(emailObserver, passwordObserver)
            .map { (email, password) in
                return !email.isEmpty && password.count >= 8
            }
    }
    
    public func signUp() {
        service.signUp(email: emailObserver.value, password: passwordObserver.value)
            .subscribe {
                
                UserDefaults.standard.setValue($0, forKey: CommonModel.UserDefault.Auth.signUpSuccess)
                UserDefaults.standard.setValue(emailObserver.value, forKey: CommonModel.UserDefault.Auth.signUpEmail)
                UserDefaults.standard.synchronize()
                
                successEvent.accept($0)
                
            } onError: { err in
                guard let err = err as? AuthError else {
                    errEvent.accept(err.localizedDescription)
                    return
                }
                
                errEvent.accept(err.errorDescription)
            }
            .disposed(by: disposeBag)
    }
    
    init(service: AuthService) {
        self.service = service
    }
}
