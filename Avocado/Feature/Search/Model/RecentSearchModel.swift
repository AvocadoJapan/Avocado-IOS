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
    @Persisted(primaryKey: true) var content: String = ""
    @Persisted var createdAt: Int64 = 0
}

