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
    public let successEvent = PublishRelay<User>()
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
            .subscribe { _ in
                // 서버 프로필 조회
                self.service.getProfile()
                    .subscribe(onNext: { user in
                        self.successEvent.accept(user)
                    })
                    .disposed(by: self.disposeBag)
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
