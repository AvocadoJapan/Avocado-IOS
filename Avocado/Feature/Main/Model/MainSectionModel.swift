//
//  MainSectionM.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import Foundation
import Differentiator

///**
// *##클래스 설명: 메인화면의 CollectionView의 각 섹션별 데이터를 RXDataStore를 이용하기 위한 클래스
// */
//
///**
// - Description: 메인화면의 각 섹션에 대한 아이템 정보
// 
// `Item`의 경우 RxDataStore에서 지원하는 typealias
// 
// `title`: 섹션헤더에 표시될 `String`
// */
//struct ProductSectionData {
//    var items: [Item]
//    var title: String?
//    var sectionId: String?
//}
//
///**
// * - Description: 메인화면의 경우 여러섹션과 각기 다른 데이터를 이용하기 때문에 각 섹션에 해당하는 데이터를 enum형식으로 구분하기 위한 enum
// *
// *  `banner`의 경우 `Banner` 클래스 데이터를 받는다 (배너 정보)
// *
// *  `product`의 경우 `product`클래스 데이터를 받는다 (상품정보)
// *
// *  `category`의 경우 `category`클래스 데이터를 받는다 (카테고리 정보)
// *
// * ** 단, 해당 값은 기본적으로 8개로 픽스되어 보여줄 예정**
// */
//enum SectionMainItem {
//    case banner(data:Banner)
//    case product(data:Product)
//    case category(data:MainSubMenuCVCell)
//}
//
//extension SectionOfMainData: SectionModelType {
//    typealias Item = SectionMainItem
//
//    init(original: SectionOfMainData, items: [SectionMainItem]) {
//        self = original
//        self.items = items
//    }
//}


struct ProductDataSection {
    var header: String?
    var items: [Product]
    var productSectionId: String?
}

extension ProductDataSection: SectionModelType {
    typealias Item = Product

    init(original: ProductDataSection, items: [Item]) {
        self = original
        self.items = items
    }
}
