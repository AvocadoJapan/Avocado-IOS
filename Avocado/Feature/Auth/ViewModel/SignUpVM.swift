//
//  SignUpVM.swift
//  Avocado
//
//  Created by FOCUSONE Inc. on 2023/06/26.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay
import RxRelay
import Amplify

/// input : 입력
/// output : 결과 화면에 보여주는 완성된 데이터
/// 회원가입 뷰모델 = 연산 + 완성된 결과 보여줌
final class SignUpVM: ViewModelType, Stepper {
    
    // RxFlow steps
    let steps: PublishRelay<Step> = PublishRelay()
    var disposeBag = DisposeBag()
    
    // 서비스를 제공하는 인스턴스
    let service: AuthService
   
    private(set) var input: Input
//    private(set) var output: Output
    
    struct Input {
        // 이메일을 입력받는 인스턴스 { value 값을 가져와야하기 때문에 BehaviorRelay로 선언 }
        let emailBehavior = BehaviorRelay<String>(value: "")
        // 비밀번호를 입력받는 인스턴스 { value 값을 가져와야하기 때문에 BehaviorRelay로 선언 }
        let passwordBehavior = BehaviorRelay<String>(value: "")
        // 비밀번호 확인을 입력받는 인스턴스 { 사용자가 입력을 했을 경우에만 값이 있어야하기 때문에 PublishRelay로 선언 }
        let passwordCheckPublish = PublishRelay<String>()
        // 이메일 정규식 확인 인스턴스
        let emailVaildPublish = PublishRelay<Bool>()
        // 패스워드 정규식 확인 인스턴스
        let passwordVaildPublish = PublishRelay<Bool>()
        // 회원가입 클릭 이벤트 인스턴스
        let actionSignUpRelay = PublishRelay<Void>()
    }
    
    struct Output {
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<AvocadoError>()
        // 회원가입 성공 이벤트를 전달하는 인스턴스
        let successEventPublish = PublishRelay<Bool>()
        // 입력된 이메일, 비밀번호, 비밀번호 확인 값의 유효성을 확인하는 인스턴스 { 초기에는 비활성화 되어야하기 때문에 BehaviorRelay로 선언 }
        let isVaildBehavior = BehaviorRelay<Bool>(value: false)
        //비밀번호와 비밀번호 확인 값이 일치하는지 검사하는 인스턴스
        let isVaildPasswordMatch = PublishRelay<Bool>()
    }
    
    // 생성자
    init(service: AuthService) {
        self.service = service
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()

        // 회원가입 클릭
        input.actionSignUpRelay
            .flatMap { [weak self] _ -> Observable<Bool> in
                return self?.service.signUp(
                    email: input.emailBehavior.value,
                    password: input.passwordBehavior.value
                )
                .catch { error in
                    if let error = error as? AvocadoError { output.errEventPublish.accept(error) }
                    return .empty()
                    
                } ?? .empty()
            }
            .subscribe { output.successEventPublish.accept($0) }
            .disposed(by: disposeBag)
        
        // 패스워드 값이 같은지 확인
        let passwordMatchVaild = PublishRelay<Bool>.combineLatest(
            input.passwordBehavior,
            input.passwordCheckPublish
        ) { password, passwordCheck in
            return !password.isEmpty && !passwordCheck.isEmpty && password == passwordCheck
        }
        
        // 이메일, 비밀번호, 비밀번호 확인값 유효성 확인
        let userInputVaild = PublishRelay<Bool>.combineLatest(
            input.emailVaildPublish,
            input.passwordVaildPublish,
            passwordMatchVaild) { emailVaild, passwordVaild, passwordcheckVaild in
            return emailVaild && passwordVaild && passwordcheckVaild
        }
        
        userInputVaild
            .bind(to: output.isVaildBehavior)
            .disposed(by: disposeBag)
        
        passwordMatchVaild
            .bind(to: output.isVaildPasswordMatch)
            .disposed(by: disposeBag)
        
        return output
    }
}
