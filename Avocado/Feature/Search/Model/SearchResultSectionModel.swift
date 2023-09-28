//
//  SearchResultSection.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/14.
//

import Foundation
import Differentiator

/**
 * - description collectionView에 보여질 sectionData
 */
struct SearchResultSection {
    var header: String?
    var categorys: [String]?
    var items: [Product]
}

extension SearchResultSection: SectionModelType {
    typealias Item = Product
    
    init(original: SearchResultSection, items: [Product]) {
        self = original
        self.items = items
    }
}
