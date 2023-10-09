//
//  ProfileDataSectionModel.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import Foundation
import Differentiator

/**
 * - description 프로필 페이지 collectionview에 보여줄 정보
 */
struct UserProfileDataSection {
    var userName: String?
    var creationDate: String?
    var header: String?
    var items: [Item]
    
    enum ProductSectionItem {
        case buyed(data: Product)
        case selled(data: Product)
        case comment(data: CommentDTO)
    }
}

extension UserProfileDataSection: SectionModelType {
    typealias Item = ProductSectionItem

    init(original: UserProfileDataSection, items: [ProductSectionItem]) {
        self = original
        self.items = items
    }
}
