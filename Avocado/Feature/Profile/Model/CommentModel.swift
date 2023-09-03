//
//  CommentModel.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/03.
//

import Foundation

/**
 * - description 상품 후기 모델 엔티티
 */
struct Comment: DTOResponseable {
    
    typealias DTO = CommentDTO
    
    let user: User
    let commentId: String
    let product: Product
    let comment: String
    let createdAt: Int64
    let updatedAt: Int64
    
    func toDTO() -> CommentDTO {
        return CommentDTO(
            name: user.nickName,
            creationDate: createdAt.dateFormatForUNIX(format: "YYYY년 MM월 DD일 거래"),
            comment: comment,
            product: product
        )
    }
}
struct CommentDTO: Decodable {
    let name: String
    let creationDate: String
    let comment: String
    let product: Product
}
