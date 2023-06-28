//
//  User.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/28.
//

import Foundation

struct User: Codable {
    let userId: String
    let nickName: String
    
    enum CodingsKey: String, CodingKey {
        case userId = "id"
        case nickName = "name"
    }
}
