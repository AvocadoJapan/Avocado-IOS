//
//  ACEmailCodeUnableVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/26.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay

final class ACEmailCodeUnableVM: ViewModelType, Stepper {
    // RxFlow steps
    let steps: PublishRelay<Step> = PublishRelay()
    var disposeBag = DisposeBag()
    
    // 서비스를 제공하는 인스턴스
    let service: AccountCenterService

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
    init(service: AccountCenterService) {
        self.service = AccountCenterService(isStub: true,
                                            sampleStatusCode: 200)
        
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}




