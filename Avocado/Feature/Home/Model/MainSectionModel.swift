//
//  MainSectionM.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import Foundation
import Differentiator

/**
 * - description 메인VC 및 단일 카테고리 상세화면에 사용하는 RXBIND 를 위한 DataSection
 */
struct ProductDataSection {
    var header: String
    var items: [Product]
    var productSectionId: String
}

extension ProductDataSection: SectionModelType {
    typealias Item = Product

    init(original: ProductDataSection, items: [Item]) {
        self = original
        self.items = items
    }
}
