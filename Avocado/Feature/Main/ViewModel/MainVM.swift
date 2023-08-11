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
        let actionMainCategoryRelay = PublishRelay<MainCategory>()
        // 단일상품 클릭 이벤트 인스턴스
        let actionSingleProductRelay = PublishRelay<Product>()
    }
    
    struct Output {
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
        
        return output
    }
    
    
    public lazy var sectionData = BehaviorRelay<[SectionOfMainData]>(value: [
        
        SectionOfMainData(items: [
            .banner(data: Banner(imageURL: "https://www.google.com")),
            .banner(data: Banner(imageURL: "https://www.google.com")),
            .banner(data: Banner(imageURL: "https://www.google.com"))
        ]),
        
        SectionOfMainData(items: [
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Apple")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Camera")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Closet")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Shoe")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Machine")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Computer")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Samsung")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "More"))
        ]),
        
        SectionOfMainData(items: [
            .product(data: Product(imageURL: "", name: "아이패드 미니 64기가 화이트 미개봉", price: "100,000원", location: "서초구 서초1동")),
            .product(data: Product(imageURL: "", name: "아이패드 미니 64기가 화이트 미개봉", price: "100,000원", location: "영등포구 여의동")),
            .product(data: Product(imageURL: "", name: "아이패드 미니 64기가 화이트 미개봉", price: "100,000원", location: "관악구 보라매동")),
            .product(data: Product(imageURL: "", name: "아이패드 미니 64기가 화이트 미개봉", price: "100,000원", location: "관악구 행운동")),
            .product(data: Product(imageURL: "", name: "아이패드 미니 64기가 화이트 미개봉", price: "100,000원", location: "강서구 화곡6동")),
            .product(data: Product(imageURL: "", name: "아이패드 미니 64기가 화이트 미개봉", price: "100,000원", location: "서초구 서초1동")),
        ], title: "한국어 데모"),

        SectionOfMainData(items: [
            .product(data: Product(imageURL: "", name: "パナソニック", price: "123,456円", location: "東京都足立区")),
            .product(data: Product(imageURL: "", name: "美味しいご飯が炊ける炊飯器", price: "123,456円", location: "東京都足立区")),
            .product(data: Product(imageURL: "", name: "涼しいエアコン10畳以上", price: "123,456円", location: "東京都渋谷区")),
            .product(data: Product(imageURL: "", name: "ダイソン掃除機未開封", price: "123,456円", location: "東京都世田谷区")),
            .product(data: Product(imageURL: "", name: "任天堂スイッチ有機EL", price: "123,456円", location: "東京都台東区")),
            .product(data: Product(imageURL: "", name: "モバイルポータブル充電器", price: "123,456円", location: "東京都港区")),
        ], title: "日本語Demo"),
    ])
    
    public let currentBannerPage = BehaviorRelay<Int>(value: 0) // 현재 배너페이지에 대한 Observable
    
}
