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
    var input: Input
    
    struct Input {
        let currentPageBehavior = BehaviorRelay<Int>(value: 0)
    }
    
    struct Output {
        let successCommentListBehavior = BehaviorRelay<[CommentListDataSection]>(value: [])
        let errorEventPublish = PublishRelay<AvocadoError>()
    }
    
    init(service: ProfileService) {
        self.service = service
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.currentPageBehavior
            .flatMap { [weak self] index in
                Logger.d("index \(index)")
                return self?.service.getCommentList(nextToken: index)
                    .catch {
                        guard let error = $0 as? AvocadoError else { return .empty() }
                        Logger.e(error)
                        output.errorEventPublish.accept(error)
                        return .empty()
                    } ?? .empty()
            }
            .map {
                Logger.d($0)
                let dtoList = $0.items.map { $0.toDTO() }
                return [CommentListDataSection(header:"거래후기", items: dtoList)]
            }
            .bind(to: output.successCommentListBehavior)
            .disposed(by: disposeBag)
        
        return output
    }
    
}
