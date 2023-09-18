//
//  CommentListVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/19.
//

import Foundation
import RxSwift
import RxRelay
import RxFlow

final class CommentListVM: ViewModelType {
    
    let service:ProfileService
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init(service: ProfileService) {
        self.service = service
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
    
}
