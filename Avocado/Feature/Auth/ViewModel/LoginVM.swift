//
//  LoginVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/26.
//

import Foundation
import RxRelay
import RxSwift
import RxFlow
import Amplify

final class LoginVM: ViewModelType {
    //MARK: - RXFlow
    var steps: PublishRelay<Step> = PublishRelay()
    
    // 서비스를 제공하는 인스턴스
    let service: AuthService
    var disposeBag = DisposeBag()
    private(set) var input: Input
    
    struct Input {
        // 이메일을 입력받는 인스턴스
        let emailBehavior = BehaviorRelay<String>(value: "")
        // 비밀번호를 입력받는 인스턴스
        let passwordBehavior = BehaviorRelay<String>(value: "")
        // 이메일 유효성 인스턴스
        let emailVaildBehavior = BehaviorRelay<Bool>(value: false)
        // 비밀번호 유효성 인스턴스
        let passwordVaildBehavior = BehaviorRelay<Bool>(value: false)
        // 로그인 버튼 클릭 액션 인스턴스
        let actionLoginPublish = PublishRelay<Void>()
    }
    
    struct Output {
        // 로그인 성공 이벤트를 전달하는 인스턴스
        let successEventPublish = PublishRelay<User>()
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<AvocadoError>()
        // 버튼 활성화 이벤트 인스턴스
        let confirmEnabledPublish = BehaviorRelay<Bool>(value: false)
    }
    
    // 생성자
    init(service: AuthService) {
        self.service = service
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.actionLoginPublish.flatMap { [weak self] _ -> Observable<Bool> in
            guard let self = self else {
                output.errEventPublish.accept(NetworkError.unknown(-1, "유효하지 않은 화면입니다"))
                return Observable.empty()
            }
            
            return self.service.login(email: input.emailBehavior.value, password: input.passwordBehavior.value)
                .catch { err in
                    if let avocadoErr = err as? AvocadoError {
                        output.errEventPublish.accept(avocadoErr)
                    }
                    return Observable.empty()
                }
        }
        .flatMap { [weak self] _ -> Observable<User> in
            guard let self = self else {
                output.errEventPublish.accept(NetworkError.unknown(-1, "유효하지 않은 화면입니다"))
                return Observable.empty()
            }
            
            return self.service.getProfile()
                .catch { err in
                    if let avocadoErr = err as? AvocadoError {
                        output.errEventPublish.accept(avocadoErr)
                    }
                    
                    return Observable.empty()
                }
        }
        .subscribe { user in
            output.successEventPublish.accept(user)
        }
        .disposed(by: disposeBag)
        
        // 이메일, 비밀번호 유효성 확인
        let buttonEnabled = PublishRelay<Bool>.combineLatest(input.emailVaildBehavior, input.passwordVaildBehavior) { emailVaild, passwordVaild in
            return emailVaild && passwordVaild
        }
        
        buttonEnabled
            .bind(to: output.confirmEnabledPublish)
            .disposed(by: disposeBag)
        
        return output
    }
}
