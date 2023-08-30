//
//  UploadVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/30.
//

import Foundation
import RxRelay
import RxSwift
import RxFlow
import Amplify

final class UploadVM: ViewModelType {
    //MARK: - RXFlow
    var steps: PublishRelay<Step> = PublishRelay()
    
    // 서비스를 제공하는 인스턴스
    let service: UploadService
    var disposeBag = DisposeBag()
    private(set) var input: Input
    
    struct Input {

    }
    
    struct Output {

    }
    
    // 생성자
    init(service: UploadService) {
        self.service = service
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
