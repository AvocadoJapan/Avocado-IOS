//
//  MainVM.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/12.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay

/**
 *## 구 클래스 설명: 메인화면에 대한 ViewModel을 구성, `sectionData`란 Observable을 이용하여 Main화면에 대한 정보를 변경해줌
 */
final class MainVM: ViewModelType, Stepper {
    
    // RxFlow steps
    let steps: PublishRelay<Step> = PublishRelay()
    var disposeBag = DisposeBag()
    
    // 서비스를 제공하는 인스턴스
    let service: MainService
    let user: User
   
    private(set) var input: Input
//    private(set) var output: Output
    
    struct Input {
        // 배너 클릭 이벤트 인스턴스
        let actionBannerRelay = PublishRelay<Banner>()
        // 메인카테고리 메뉴 클릭 이벤트 인스턴스
        let actionMainCategoryRelay = PublishRelay<MainCategoryMenu>()
        // 단일상품 클릭 이벤트 인스턴스
        let actionSingleProductRelay = PublishRelay<Product>()
        // viewDidLoad가 탓음을 감지하는 인스턴스
        let actionViewDidLoad = PublishRelay<Void>()
    }
    
    struct Output {
        // 배너 정보를 전달하는 인스턴스
        let bannerSectionDataPublish = PublishRelay<[Banner]>()
        // 상품 데이터를 전달하는 인스턴스
        let productSectionDataPublish = PublishRelay<[ProductSection]>()
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<NetworkError>()
    }
    
    // 생성자
    init(service: MainService, user: User) {
        self.service = service
        self.user = user
        
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.actionViewDidLoad.flatMap { [weak self] _ in
            guard let self = self else { throw NetworkError.unknown(-1, "유효하지 않은 화면입니다") }
            return {}
        }
        .subscribe { _ in
//            output.errEventPublish.accept(regions)
        } onError: { error in
            if let error = error as? NetworkError {
                output.errEventPublish.accept(error)
            }
            else {
                output.errEventPublish.accept(NetworkError.unknown(-1, error.localizedDescription))
            }
        }
        .disposed(by: disposeBag)
        
        return output
    }
}
