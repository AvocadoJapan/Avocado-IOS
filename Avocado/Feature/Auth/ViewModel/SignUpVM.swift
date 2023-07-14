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

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

/// input : 입력
/// output : 결과 화면에 보여주는 완성된 데이터
/// 회원가입 뷰모델 = 연산 + 완성된 결과 보여줌
final class SignUpVM : ViewModelType {
 
    private let service: AuthService
    private let disposeBag = DisposeBag()
    
    var inputActionPublishRelay = PublishRelay<InputAction>()
    
    enum InputAction {
        case signUp(email: String, password: String)
        case signOut
    }
    
    struct Input {
//        public let emailObserver = BehaviorRelay<String>(value: "")
//        public let passwordObserver = BehaviorRelay<String>(value: "")
//        public let passwordCheckObserver = BehaviorRelay<String>(value: "")
//        // action
//        let signupActionPublisherRelay = PublishRelay<Void>()
    }
    
    struct Output {
//        public let errEvent = PublishRelay<String>()
//        public let successEvent = PublishRelay<Bool>()
//        public var isVaild: Observable<Bool> {
//
//            return Observable
//                .combineLatest(emailObserver, passwordObserver, passwordCheckObserver)
//                .map { (email, password, passwordCheck) in
//                    return !email.isEmpty &&
//                    !password.isEmpty &&
//                    !passwordCheck.isEmpty &&
//                    (password == passwordCheck)
//                }
//        }
    }
    
    func transform(input: Input) -> Output {
        
        // 비즈니스 로직 행하기
//        input.signupActionPublisherRelay
//            .subscribe(onNext: {
//                service.signUp(email: input.emailObserver.value, password: input.passwordObserver.value)
//                    .subscribe {
//                        UserDefaults.standard.setValue($0, forKey: CommonModel.UserDefault.Auth.signUpSuccess)
//                        UserDefaults.standard.synchronize()
//                        output.successEvent.accept($0)
//                    } onError: { err in
//                        guard let err = err as? AuthError else {
//                            self.errEvent.accept(err.localizedDescription)
//                            return
//                        }
//                        self.errEvent.accept(err.errorDescription)
//                    }
//                    .disposed(by: disposeBag)
//            }).disposed(by: disposeBag)
        return Output()
    }
    
    //MARK: - INPUT
    public let emailObserver = BehaviorRelay<String>(value: "")

    public let passwordObserver = BehaviorRelay<String>(value: "")

    public let passwordCheckObserver = BehaviorRelay<String>(value: "")
    /// ====

    //MARK: - OUTPUT
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
