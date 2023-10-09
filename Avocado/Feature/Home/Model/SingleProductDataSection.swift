//
//  SingleProductDataSection.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/10/08.
//

import Foundation
import Differentiator

/**
 * - description 단일 상품 화면 데이터 바인딩을 위한 RxDatasource
 */
struct SingleProductDataSection {
    var sectionTitle: String?
    var items: [Item]
    
    enum SingleProductDataItem {
        case image(data: String)
        case title(data: Product)
        case profile(data: User)
        case badge(data: ProductBadge)
        case description(data: String)
        case recomendation(data: Product)
    }
}

extension SingleProductDataSection: SectionModelType {
    typealias Item = SingleProductDataItem

    init(original: SingleProductDataSection, items: [SingleProductDataItem]) {
        self = original
        self.items = items
    }
}
