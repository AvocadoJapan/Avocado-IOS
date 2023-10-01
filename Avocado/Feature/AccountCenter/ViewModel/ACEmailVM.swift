//
//  ACEmailVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/25.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay

final class ACEmailVM: ViewModelType, Stepper {
    // RxFlow steps
    let steps: PublishRelay<Step> = PublishRelay()
    var disposeBag = DisposeBag()
    
    // 서비스를 제공하는 인스턴스
    let service: AccountCenterService
    
    // 어떤 메뉴를 통해 들어왔는지 관리하는 인스턴스
    let type: AccountCenterDataType
    
    private(set) var input: Input
    
    struct Input {
        // viewDidLoad를 감지하는 인스턴스
        let actionViewDidLoadPublish = PublishRelay<Void>()
        // 이메일을 입력받는 인스턴스
        let emailBehavior = BehaviorRelay<String>(value: "")
        // 이메일 유효성 인스턴스
        let emailVaildBehavior = BehaviorRelay<Bool>(value: false)
        // 확인 버튼 클릭 액션 인스턴스
        let actionConfirmPublish = PublishRelay<Void>()
    }
    
    struct Output {
        // type 정보를 바탕으로 선택된 메뉴의 타이틀을 전달하는 인스턴스
        let navigationTitlePublish = PublishRelay<String>()
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<AvocadoError>()
        // 버튼 활성화 이벤트 인스턴스
        let confirmEnabledPublish = BehaviorRelay<Bool>(value: false)
    }
    
    // 생성자
    init(service: AccountCenterService,
         type: AccountCenterDataType) {
        self.service = AccountCenterService(isStub: true,
                                            sampleStatusCode: 200)
        self.type = type
        
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // 확인버튼을 눌럿을때 수행
        input.actionConfirmPublish
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                // 타입 검사
                if self.type == .findPassword {
                    // 이메일 인증화면으로 이동
                    self.steps.accept(AccountCenterStep.emailCheckIsRequired(type: self.type,
                                                                             email: self.input.emailBehavior.value))
                } else {
                    // 비밀번호 입력 화면으로 이동
                    self.steps.accept(AccountCenterStep.passwordIsRequired(type: self.type,
                                                                           email: self.input.emailBehavior.value))
                }
            })
            .disposed(by: disposeBag)
        
        // 화면이 로드 되었을때 타이틀 설정
        input.actionViewDidLoadPublish
            .map { [weak self] in
                self?.type.navigationTitle ?? ""
            }
            .bind(to: output.navigationTitlePublish)
            .disposed(by: disposeBag)
        
        // 이메일이 유효할때 버튼 활성화
        input.emailVaildBehavior
            .bind(to: output.confirmEnabledPublish)
            .disposed(by: disposeBag)
        
        return output
    }
}


