//
//  LoginVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/26.
//

import Foundation
import RxRelay
import RxSwift
import Amplify

final class LoginVM {
    private let service: AuthService
    private let disposeBag = DisposeBag()
    
    public let emailObserver = BehaviorRelay<String>(value: "")
    public let passwordObserver = BehaviorRelay<String>(value: "")
    public let successEvent = PublishRelay<Bool>()
    public let errEvent = PublishRelay<String>()
    public var isVaild: Observable<Bool> {
        return Observable
            .combineLatest(emailObserver, passwordObserver)
            .map { (email, password) in
                return !email.isEmpty && password.count >= 8
            }
    }
    
    
    init(service: AuthService) {
        self.service = service
    }
    
    func login() {
        service.login(email: emailObserver.value, password: passwordObserver.value)
            .subscribe {
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
    
}
