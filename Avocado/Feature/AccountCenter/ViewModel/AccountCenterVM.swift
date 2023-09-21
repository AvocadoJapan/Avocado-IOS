//
//  AccountCenterVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/20.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay

final class AccountCenterVM: ViewModelType, Stepper {
    // RxFlow steps
    let steps: PublishRelay<Step> = PublishRelay()
    var disposeBag = DisposeBag()
    
    // 서비스를 제공하는 인스턴스
    let service: MainService

    private(set) var input: Input
    
    struct Input {
        // viewDidLoad를 감지하는 인스턴스
        let actionViewDidLoad = PublishRelay<Void>()
    }
    
    struct Output {
        // 계정센터 테이블뷰 내용을 전달하는 인스턴스
        let dataSectionPublish = PublishRelay<[AccountCenterDataSection]>()
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<AvocadoError>()
    }
    
    // 생성자
    init(service: MainService) {
        self.service = MainService(isStub: true, sampleStatusCode: 200)
        
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()

        input.actionViewDidLoad
            .map {
                // 1. AccountCenterDataType 의 모든 케이스를 가져온후
                let allAccountCenterData: [AccountCenterData] = AccountCenterDataType.allCases.map { AccountCenterData(type: $0) }
                
                // 2. allAccountCenterData를 DataSection으로 가공합니다.
                let accountCenterDataSection = AccountCenterDataSection(items: allAccountCenterData)
                
                Logger.d(accountCenterDataSection)
                
                return [accountCenterDataSection]
            }
            .bind(to: output.dataSectionPublish)
            .disposed(by: disposeBag)
        
        return output
    }
}

