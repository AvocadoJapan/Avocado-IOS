//
//  AvatarM.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/28.
//

import Foundation

/**
 * - Description 유저 아바타 정보
 */
struct Avatar: Codable {
    let id: String
    let changedAt: Int64
    
    enum CodingKeys: String, CodingKey {
        case id = "imageId"
        case changedAt = "changedAt"
    }
}
