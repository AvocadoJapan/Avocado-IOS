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
    let regionId: Int // 지역 아이디
    let name: String // 지역 명
    
    enum CodingKeys: String, CodingKey {
        case regionId = "id"
        case name = "name"
    }
}

typealias Regions = [Region]
