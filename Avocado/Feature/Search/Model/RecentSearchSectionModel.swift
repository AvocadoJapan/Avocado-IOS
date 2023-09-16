//
//  RecentSearchSectionModel.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/09.
//

import Foundation
import Differentiator

/**
 * - description collectionView에 보여질 sectionData  
 */
struct RecentSearchSection {
    let header: String?
    var items: [Item]
}

extension RecentSearchSection: SectionModelType {
    typealias Item = RecentSearchEntity
    
    init(original: RecentSearchSection, items: [RecentSearchEntity]) {
        self = original
        self.items = items
    }
}
