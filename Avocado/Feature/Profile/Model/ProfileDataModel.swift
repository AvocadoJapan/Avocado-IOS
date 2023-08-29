//
//  ProfileDataModel.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import Foundation

struct UserProfile: DTOResponseable {
    typealias DTO = UserProfileDTO
    
    let user: User
    let sellProduct: [Product]
    let buyProduct: [Product]
    
    func toDTO() -> UserProfileDTO {
        let fomatter = DateFormatter()
        fomatter.dateFormat = "YYYY년 MM월 DD일 가입"
        let date = Date(timeIntervalSince1970: TimeInterval(user.createdAt))
        let dateString = fomatter.string(from: date)
        
        return UserProfileDTO(name: user.nickName,
                              sellProductCount: sellProduct.count,
                              buyProductCount: buyProduct.count,
                              creationDate: dateString,
                              sellProduct: sellProduct,
                              buyProduct: buyProduct)
    }
}

struct UserProfileDTO: Decodable {
    let name: String
    let sellProductCount: Int
    let buyProductCount: Int
    let creationDate: String
    let sellProduct: [Product]
    let buyProduct: [Product]
}
