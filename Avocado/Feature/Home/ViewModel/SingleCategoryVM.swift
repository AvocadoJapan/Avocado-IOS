//
//  SingleCategoryVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/13.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay

final class SingleCategoryVM: ViewModelType, Stepper {
    // RxFlow steps
    let steps: PublishRelay<Step> = PublishRelay()
    var disposeBag = DisposeBag()
    
    // 서비스를 제공하는 인스턴스
    let service: MainService
    
    private(set) var input: Input
//    private(set) var output: Output
    
    struct Input {
        // viewDidLoad를 감지하는 인스턴스 (초기 data fetching 에 사용)
        let actionViewDidLoad = PublishRelay<Void>()
    }
    
    struct Output {
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<NetworkError>()
    }
    
    // 생성자
    init(service: MainService) {
        self.service = service
        
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
