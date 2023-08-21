//
//  SingleProductVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/20.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay

final class SingleProductVM: ViewModelType, Stepper {
    // RxFlow steps
    let steps: PublishRelay<Step> = PublishRelay()
    var disposeBag = DisposeBag()
    
    // 서비스를 제공하는 인스턴스
    let service: MainService
    let user: User
    let product: Product
    
    private(set) var input: Input
//    private(set) var output: Output
    
    struct Input {
        // 배너 클릭 이벤트 인스턴스
        let actionBannerRelay = PublishRelay<Banner>()
        // 메인카테고리 메뉴 클릭 이벤트 인스턴스
        let actionMainCategoryRelay = PublishRelay<Category>()
        // 단일상품 클릭 이벤트 인스턴스
        let actionSingleProductRelay = PublishRelay<Product>()
    }
    
    struct Output {
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<NetworkError>()
    }
    
    // 생성자
    init(service: MainService, user: User, product: Product) {
        self.service = service
        self.user = user
        self.product = product
        
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
