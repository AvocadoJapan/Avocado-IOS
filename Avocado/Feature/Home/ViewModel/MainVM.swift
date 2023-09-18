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
    
    private(set) var input: Input
    //    private(set) var output: Output
    
    struct Input {
        // 배너 클릭 이벤트 인스턴스
        let actionBannerRelay = PublishRelay<Banner>()
        // 메인카테고리 메뉴 클릭 이벤트 인스턴스
        let actionMainCategoryRelay = PublishRelay<MainCategoryMenu>()
        // 단일상품 클릭 이벤트 인스턴스
        let actionSingleProductRelay = PublishRelay<Product>()
        // 단일카테고리 클릭 이벤트 인스턴스
        let actionSingleCategoryRelay = PublishRelay<String>()
        // viewDidLoad를 감지하는 인스턴스 (초기 data fetching 에 사용)
        let actionViewDidLoad = PublishRelay<Void>()
    }
    
    struct Output {
        // 배너 정보를 전달하는 인스턴스
        let bannerSectionDataPublish = PublishRelay<[Banner]>()
        // 상품 데이터를 전달하는 인스턴스
        let productSectionDataPublish = PublishRelay<[ProductDataSection]>()
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<NetworkError>()
    }
    
    // 생성자
    init(service: MainService) {
        self.service = MainService(isStub: true, sampleStatusCode: 200)
        //        self.service = service
        
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // viewDidLoad가 실행될때 mainData를 fetch
        input.actionViewDidLoad.flatMap { [weak self] _ in
            guard let self = self else { throw NetworkError.unknown(-1, "유효하지 않은 화면입니다") }
            let mainData = service.getMain()
            
            return mainData
        }
        .subscribe { mainData in
            output.bannerSectionDataPublish.accept(mainData.bannerList)
            
            var arr: [ProductDataSection] = []
            
            mainData.productSection.forEach { data in
                arr.append(data.toDTO())
            }
            
            output.productSectionDataPublish.accept(arr)
        } onError: { error in
            Logger.e(error)
            if let error = error as? NetworkError {
                output.errEventPublish.accept(error)
            }
            else {
                output.errEventPublish.accept(NetworkError.unknown(-1, error.localizedDescription))
            }
        }
        .disposed(by: disposeBag)
        
        // 단일 상품 클릭시 화면이동
        input.actionSingleProductRelay
            .subscribe { [weak self] product in
                Logger.d("\(product)")
                self?.steps.accept(MainStep.singleProductIsRequired(product: Product(productId: "smaple", mainImageId: "smaple", imageIds: ["smaple"], name: "smaple", price: "smaple", location: "smaple")))
            }
            .disposed(by: disposeBag)
        
        // 단일 카테고리 클릭시 화면이동
        input.actionSingleCategoryRelay
            .subscribe { [weak self] id in
                Logger.d("Category ID : \(id)")
                self?.steps.accept(MainStep.singleCategoryIsRequired(id: id))
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
