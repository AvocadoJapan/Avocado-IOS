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
    let service: AccountCenterService

    private(set) var input: Input
    
    struct Input {
        // viewDidLoad를 감지하는 인스턴스
        let actionViewDidLoadPublish = PublishRelay<Void>()
        // 어떤 셀이 눌렸는지 감지하는 인스턴스
        let actionTVCellRelay = PublishRelay<AccountCenterDataType>()
    }
    
    struct Output {
        // 계정센터 테이블뷰 내용을 전달하는 인스턴스
        let dataSectionPublish = PublishRelay<[AccountCenterDataSection]>()
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<AvocadoError>()
    }
    
    // 생성자
    init(service: AccountCenterService) {
        self.service = AccountCenterService(isStub: true, sampleStatusCode: 200)
        
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()

        input.actionViewDidLoadPublish
            .map {
                return AccountCenterData.getDataList()
            }
            .bind(to: output.dataSectionPublish)
            .disposed(by: disposeBag)
        
        // TVCell 클릭시 화면이동
        input.actionTVCellRelay
            .filter { type in
                type == .findPassword ||
                type == .confirmCodeUnvalid ||
                type == .accountDelete ||
                type == .accountHacked ||
                type == .accountLocked
            }
            .subscribe(onNext: { [weak self] type in
                Logger.d("type: \(type)")
                self?.steps.accept(AccountCenterStep.emailIsRequired(type: type))
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

