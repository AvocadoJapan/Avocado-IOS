//
//  MainSectionM.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import Foundation
import Differentiator

struct SectionOfMainData {
    var items: [Item]
}

enum SectionMainItem {
    case banner(data:Banner)
    case product(data:Product)
    case category(data:MainCategory)
}

extension SectionOfMainData: SectionModelType {
    typealias Item = SectionMainItem

    init(original: SectionOfMainData, items: [SectionMainItem]) {
        self = original
        self.items = items
    }
    
    
}
