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
import RxDataSources

final class SingleProductVM: ViewModelType, Stepper {
    // RxFlow steps
    let steps: PublishRelay<Step> = PublishRelay()
    var disposeBag = DisposeBag()
    
    // 서비스를 제공하는 인스턴스
    let service: MainService
    let product: Product
    
    private(set) var input: Input
    //    private(set) var output: Output
    
    struct Input {
        // viewDidLoad를 감지하는 인스턴스 (초기 data fetching 에 사용)
        let actionViewDidLoad = PublishRelay<Void>()
    }
    
    struct Output {
        // 데이터소스를 전달하는 인스턴스
        let dataSourcePublish = PublishRelay<[SingleProductDataSection]>()
        // 에러 이벤트를 전달하는 인스턴스
        let errEventPublish = PublishRelay<NetworkError>()
    }
    
    // 생성자
    init(service: MainService, product: Product) {
        self.service = service
        self.product = product
        
        input = Input()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        // 데모데이터
        var demoProduct: Product = Product(productId: "",
                                           mainImageId: "",
                                           imageIds: [""],
                                           name: "",
                                           price: "",
                                           location: "")
        var demoImage: String = ""
        var demoUser: User = User(userId: "1234",
                                  nickName: "Avocado demo",
                                  updateAt: 0,
                                  createdAt: 0,
                                  accounts: .init(cognito: "demo"),
                                  avatar: nil)
        
        input.actionViewDidLoad.subscribe(onNext: {
            
            output.dataSourcePublish.accept([
                
                // 제품사진
                SingleProductDataSection(sectionTitle: nil,
                                         items: [.image(data: demoImage),
                                                 .image(data: demoImage),
                                                 .image(data: demoImage)]),
                // 제목
                SingleProductDataSection(sectionTitle: nil,
                                         items: [.title(data: demoProduct)]),
                // 업로더 프로필
                SingleProductDataSection(sectionTitle: nil,
                                         items: [.profile(data: demoUser)]),
                // 배지
                SingleProductDataSection(sectionTitle: "상품 배지",
                                         items: [.badge(data: .avocadoPay),
                                                 .badge(data: .business),
                                                 .badge(data: .freeShipping)]),
                // 설명
                SingleProductDataSection(sectionTitle: "상품 설명",
                                         items: [.description(data:
                                                                """
                                                                2023년 4월 말에 구입
                                                                
                                                                - 아이패드 프로 5세대 M1 128기가 스페이스그레이입니다.
                                                                - 외관 S급입니다. 기능 이상 없습니다.
                                                                - 배터리효율 85퍼센트입니다.
                                                                - 구성은 풀박스에 펜슬수납 가능 케이스 함께 드립니다.
                                                                
                                                                오늘(27일) 구입한 아이패드 미니6 와이파이버전 64기가 모델을 팝니다..
                                                                오늘 쿠팡에서 새걸로 구입한 겁니다..
                                                                
                                                                박스 내용물 다 있습니다..
                                                                바로 가져가실분 연락주세요..
                                                                """
                                                             )]),
                // 작은 상품
                SingleProductDataSection(sectionTitle: "관련 상품",
                                         items: [.recomendation(data: demoProduct),
                                                 .recomendation(data: demoProduct),
                                                 .recomendation(data: demoProduct),
                                                 .recomendation(data: demoProduct),
                                                 .recomendation(data: demoProduct),
                                                 .recomendation(data: demoProduct)])
            ])
            
        }).disposed(by: disposeBag)
        
        return output
    }
}
