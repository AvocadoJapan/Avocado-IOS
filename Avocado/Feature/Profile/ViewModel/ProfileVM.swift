//
//  ProfileVM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

final class ProfileVM: ViewModelType {
    let service: ProfileService
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    private(set) var input: Input
    
    struct Input {
        let actionViewDidLoad = PublishRelay<Void>()
        let currentPageBehavior = BehaviorRelay<Int>(value: 0)
    }
    
    struct Output {
        let successProfileEventDateSourcePublish = PublishRelay<[UserProfileDataSection]>()
        let errorEventPublish = PublishRelay<AvocadoError>()
    }
    
    init(service: ProfileService) {
//        self.service = service
        self.service = ProfileService(isStub: true, sampleStatusCode: 200) // Mocking Code
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.actionViewDidLoad
            .flatMap { [weak self] _ in
                return self?.service.getProfilePage()
                    .catch { error in
                        if let error = error as? AvocadoError { output.errorEventPublish.accept(error) }
                        return .empty()
                    } ?? .empty()
            }
            .subscribe(onNext: {
                Logger.d($0)
                let buyProduct = $0.buyProduct.map { UserProfileDataSection.ProductSectionItem.buyed(data: $0) }
                let sellProduct = $0.sellProduct.map { UserProfileDataSection.ProductSectionItem.selled(data: $0) }
                let comment = $0.comments.map { UserProfileDataSection.ProductSectionItem.comment(data: $0) }
                
                output.successProfileEventDateSourcePublish.accept([
                    UserProfileDataSection(
                        userName: $0.name,
                        creationDate: $0.creationDate,
                        header: "\($0.name)와 거래 후기",
                        items: comment
                    ),
                    
                    UserProfileDataSection(
                        header: "현재 판매중인 상품",
                        items: sellProduct
                    ),
                    
                    UserProfileDataSection(
                        header: "현재 판매완료 된 상품",
                        items: buyProduct
                    )
                ])
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
