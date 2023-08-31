//
//  ProfileDataSectionModel.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import Foundation
import Differentiator

struct UserProfileDataSection {
    var userName: String?
    var userGrade: String?
    var userVerified: String?
    var creationDate: String?
    var productTitle: String?
    var items: [Item]
    
    enum ProductSectionItem {
        case buyed(data: Product)
        case selled(data: Product)
    }
}

extension UserProfileDataSection: SectionModelType {
    typealias Item = ProductSectionItem

    init(original: UserProfileDataSection, items: [ProductSectionItem]) {
        self = original
        self.items = items
    }
}
