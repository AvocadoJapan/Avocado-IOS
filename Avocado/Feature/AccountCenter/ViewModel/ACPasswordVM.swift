//
//  ACPasswordVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/25.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay

final class ACPasswordVM: ViewModelType, Stepper {
    // RxFlow steps
    let steps: PublishRelay<Step> = PublishRelay()
    var disposeBag = DisposeBag()
    
    // 서비스를 제공하는 인스턴스
    let service: AccountCenterService

    // 어떤 메뉴를 통해 들어왔는지 관리하는 인스턴스
    let type: AccountCenterDataType

    
    private(set) var input: Input
    
    struct Input {
        let emailBehavior = BehaviorRelay<String>(value: "")
        // viewDidLoad를 감지하는 인스턴스
        let actionViewDidLoadPublish = PublishRelay<Void>()
    }
    
    struct Output {
        let emailPublish = PublishRelay<String>()
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<AvocadoError>()
    }
    
    // 생성자
    init(service: AccountCenterService,
         email: String,
         type: AccountCenterDataType) {
        self.service = AccountCenterService(isStub: true,
                                            sampleStatusCode: 200)
        self.type = type
        
        input = Input()
        input.emailBehavior.accept(email)
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
//        
//        Logger.d(email)
//        
//        // emailPublish에 주입받은 email accept
//        output.emailPublish
//            .accept(email)
        
        return output
    }
}
