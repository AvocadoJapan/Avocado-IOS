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
struct User: DTOResponseable {
    typealias DTO = UserDTO
    
    let userId: String // 유저 아이디
    let nickName: String// 유저 닉네임
    let updateAt: Int64 // 업데이트 시간
    let createdAt: Int64 // 생성 시간
    let accounts: Accounts // 로그인 정보
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case nickName = "name"
        case updateAt = "updatedAt"
        case createdAt = "createdAt"
        case accounts = "accounts"
    }
    
    func toDTO() -> UserDTO {
        return UserDTO(nickName: nickName)
    }
}

struct Accounts:Decodable {
    let cognito: String
}

struct UserDTO: Decodable {
    let nickName: String
}
