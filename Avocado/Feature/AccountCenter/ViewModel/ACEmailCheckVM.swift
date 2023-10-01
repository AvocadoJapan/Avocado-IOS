//
//  ACEmailCheckVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/25.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay

final class ACEmailCheckVM: ViewModelType, Stepper {
    // RxFlow steps
    let steps: PublishRelay<Step> = PublishRelay()
    var disposeBag = DisposeBag()
    
    // 서비스를 제공하는 인스턴스
    let service: AccountCenterService
    
    // 어떤 메뉴를 통해 들어왔는지 관리하는 인스턴스
    let type: AccountCenterDataType

    private(set) var input: Input
    
    struct Input {
        // 이전 단계로부터 이메일을 받는 인스턴스
        let emailBehavior = BehaviorRelay<String>(value: "")
        // viewDidLoad를 감지하는 인스턴스
        let actionViewDidLoadPublish = PublishRelay<Void>()
    }
    
    struct Output {
        // type 정보를 바탕으로 선택된 메뉴의 타이틀을 전달하는 인스턴스
        let navigationTitlePublish = PublishRelay<String>()
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<AvocadoError>()
    }
    
    // 생성자
    init(service: AccountCenterService,
         type: AccountCenterDataType,
         email: String) {
        self.service = AccountCenterService(isStub: true,
                                            sampleStatusCode: 200)
        self.type = type
        
        input = Input()
        input.emailBehavior.accept(email)
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // 화면이 로드 되었을때 타이틀 설정
        input.actionViewDidLoadPublish
            .map { [weak self] in
                self?.type.navigationTitle ?? ""
            }
            .bind(to: output.navigationTitlePublish)
            .disposed(by: disposeBag)
        
        return output
    }
}
