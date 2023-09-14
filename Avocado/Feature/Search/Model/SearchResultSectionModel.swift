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
    var items: [Item]
    
    enum SearchResultSectionItem {
        case category(data: String)
        case product(data: Product)
    }
}

extension SearchResultSection: SectionModelType {
    typealias Item = SearchResultSectionItem
    
    init(original: SearchResultSection, items: [SearchResultSectionItem]) {
        self = original
        self.items = items
    }
}
