//
//  User.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/28.
//

import Foundation
/**
 * - Description 사용자 정보 모델
 */
struct User: Codable {
    let userId: String // 유저 아이디
    let nickName: String// 유저 닉네임
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case nickName = "name"
    }
}
