//
//  ProfileDataModel.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import Foundation
/**
 * - description 프로필 화면 정보 엔티티
 */
struct UserProfile: DTOResponseable {
    typealias DTO = UserProfileDTO
    
    let user: User
    let sellProduct: [Product]
    let buyProduct: [Product]
    let comments: [Comment]
    
    func toDTO() -> UserProfileDTO {
        return UserProfileDTO(
            name: user.nickName,
            creationDate: user.createdAt.dateFormatForUNIX(format: "YYYY년 MM월 DD일 가입"),
            sellProduct: sellProduct,
            buyProduct: buyProduct,
            comments: comments.map { $0.toDTO() }
        )
    }
}

struct UserProfileDTO: Decodable {
    let name: String
    let creationDate: String
    let sellProduct: [Product]
    let buyProduct: [Product]
    let comments: [CommentDTO]
}
