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

/// input : 입력
/// output : 결과 화면에 보여주는 완성된 데이터
/// 회원가입 뷰모델 = 연산 + 완성된 결과 보여줌
final class SignUpVM {
 
    // 서비스를 제공하는 인스턴스
    private let authService: AuthService
    private let disposeBag = DisposeBag()
    
    // 사용자 입력에 따른 액션을 받는 인스턴스
    var inputActionPublishRelay = PublishRelay<InputAction>()
    
    // 사용자 입력 액션을 나타내는 enum
    enum InputAction {
        case signUp(email: String, password: String)
        case signOut
    }
    
    struct Input { }
    
    struct Output { }
    
    //MARK: - INPUT
    // 이메일을 입력받는 인스턴스
    public let emailBehavior = BehaviorRelay<String>(value: "")
    // 비밀번호를 입력받는 인스턴스
    public let passwordBehavior = BehaviorRelay<String>(value: "")
    // 비밀번호 확인을 입력받는 인스턴스
    public let passwordCheckBehavior = BehaviorRelay<String>(value: "")

    //MARK: - OUTPUT
    // 에러 이벤트를 전달하는 인스턴스
    public let errEventPublish = PublishRelay<String>()
    // 회원가입 성공 이벤트를 전달하는 인스턴스
    public let successEventPublish = PublishRelay<Bool>()
    // 입력된 이메일, 비밀번호, 비밀번호 확인 값의 유효성을 확인하는 인스턴스
    public var isValidObservable: Observable<Bool> {

        return Observable
            .combineLatest(emailBehavior, passwordBehavior, passwordCheckBehavior)
            .map { (email, password, passwordCheck) in
                return !email.isEmpty &&
                !password.isEmpty &&
                !passwordCheck.isEmpty &&
                (password == passwordCheck)
            }
    }
    
    // 회원가입 요청하는 함수
    public func signUp() {
        authService.signUp(email: emailBehavior.value, password: passwordBehavior.value)
            .subscribe {
                UserDefaults.standard.setValue($0, forKey: CommonModel.UserDefault.Auth.signUpSuccess)
                UserDefaults.standard.synchronize()
                self.successEventPublish.accept($0)
            } onError: { err in
                guard let err = err as? AuthError else {
                    self.errEventPublish.accept(err.localizedDescription)
                    return
                }
                self.errEventPublish.accept(err.errorDescription)
            }
            .disposed(by: disposeBag)
    }
    
    // 비밀번호와 비밀번호 확인 값이 일치하는지 검사하는 함수
    public func validatePasswordMatch() -> String {
        let password = self.passwordBehavior.value
        let passwordCheck = self.passwordCheckBehavior.value
        return password != passwordCheck ? "비밀번호가 일치하지 않습니다." : ""
    }
    
    // 생성자
    init(service: AuthService) {
        self.authService = service
    }
}
