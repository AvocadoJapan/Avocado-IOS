//
//  Regions.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/28.
//

import Foundation
/**
 * - Description 활동지역 모델
 */
struct Region: Codable {
    let id: String
    let name: String
    let fullName: String
    let depth: Int
    let parentID: String

    enum CodingKeys: String, CodingKey {
        case id, name, fullName, depth
        case parentID = "parentId"
    }
}

typealias Regions = [Region]
