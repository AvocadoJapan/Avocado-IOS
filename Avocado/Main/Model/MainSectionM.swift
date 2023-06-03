//
//  MainSectionM.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import Foundation
import Differentiator

struct MainTitleItem {
    let imageList: [String]
    let categoryList: [String]
    let title: String
}

enum MainSectionM {
    case SectionTitle(header:MainTitleItem, items:[Product])
    case SectionCategory(header:String, items: [Product])
}

extension MainSectionM: SectionModelType {
    
    typealias Item = Product
    
    var items: [Product] {
        switch self {
        case let .SectionTitle(header: _, items: items):
            return items.map { $0 }
        case let .SectionCategory(header: _, items: items):
            return items.map { $0 }
        }
    }
    
    init(original: MainSectionM, items: [Product]) {
        switch original {
            
        case let .SectionTitle(header: header, items: items):
            self = .SectionTitle(header: header, items: items)
            
        case let .SectionCategory(header: header, items: items):
            self = .SectionCategory(header: header, items: items)
            
        
        }
    }
}
