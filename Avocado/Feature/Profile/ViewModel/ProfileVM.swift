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
                
                let buyedDataSections = $0.buyProduct.map {
                    return UserProfileDataSection.ProductSectionItem.buyed(data: $0)
                }
                
                let selledDataSections = $0.sellProduct.map { UserProfileDataSection.ProductSectionItem.selled(data: $0) }
                
               let userDataSections = [
                UserProfileDataSection(userName: $0.name,
                                       userGrade: "⭐ 프리미엄 판매자",
                                       userVerified: "⚠️ 본인인증 미완료",
                                       creationDate: $0.creationDate,
                                       items: [
                                        .slider(title: "구매 \($0.buyProductCount)"),
                                        .slider(title: "판매 \($0.sellProductCount)")
                                       ]),
                UserProfileDataSection(items: buyedDataSections),
                UserProfileDataSection(items: selledDataSections),
               ]
                
                output.successProfileEventDateSourcePublish.accept(userDataSections)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
