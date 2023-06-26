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
    public let errEvent = BehaviorRelay<String>(value: "")
    public let successEvent = BehaviorRelay<Bool>(value:false)
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
