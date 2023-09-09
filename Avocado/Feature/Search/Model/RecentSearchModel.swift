//
//  RecentSearchModel.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/09.
//

import Foundation
import RealmSwift

/*
 * - description 최근 검색어 Realm database 파일
 */
final class RecentSearchEntity: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var content: String = ""
    @objc dynamic var createdAt: Int64 = 0
    
    // 기본 키
    override class func primaryKey() -> String? {
        return "id"
    }
}

