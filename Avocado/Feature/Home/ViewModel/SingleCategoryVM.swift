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
    
    let categoryId: String
    
    private(set) var input: Input
//    private(set) var output: Output
    
    struct Input {
        // viewDidLoad를 감지하는 인스턴스 (초기 data fetching 에 사용)
        let actionViewDidLoad = PublishRelay<Void>()
        // 단일상품 클릭 이벤트 인스턴스
        let actionSingleProductRelay = PublishRelay<Product>()
    }
    
    struct Output {
        // 단일 카테고리 데이터를 전달하는 인스턴스
        let singleCategoryProductListPublish = PublishRelay<[ProductDataSection]>()
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<AvocadoError>()
    }
    
    // 생성자
    init(service: MainService, id: String) {
        self.service = MainService(isStub: true, sampleStatusCode: 200)
        self.categoryId = id
        
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.actionViewDidLoad
            .flatMap { [weak self] _  in
                return self?.service.getSingleCategoryProductList(id: self?.categoryId ?? "")
                    .catch { error in
                        if let error = error as? AvocadoError {
                            output.errEventPublish.accept(error)
                        }
                        return .empty()
                    } ?? .empty()
            }
            .map {
                return [$0.toDTO()]
            }
            .bind(to: output.singleCategoryProductListPublish)
            .disposed(by: disposeBag)
        
        // 단일 상품 클릭시 화면이동
        input.actionSingleProductRelay
            .subscribe { [weak self] product in
                Logger.d("\(product)")
                self?.steps.accept(MainStep.singleProductIsRequired(product: Product(productId: "smaple", mainImageId: "smaple", imageIds: ["smaple"], name: "smaple", price: "smaple", location: "smaple")))
            }
            .disposed(by: disposeBag)
        
        
        
        return output
    }
}
