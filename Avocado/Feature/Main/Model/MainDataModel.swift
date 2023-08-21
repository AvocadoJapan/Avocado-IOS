//
//  MainDataM.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import Foundation

// MARK: - Model
struct MainDataModel: Codable {
    let userID: String
    let bannerList: [Banner]
    let productSection: [ProductSection]
}

// MARK: - BannerList
struct Banner: Codable {
    let id: String
    let name: String
    let imageId: String
}

// MARK: - ProductSection
struct ProductSection: Codable {
    let id: String
    let name: String
    let products: [Product]
}

// MARK: - Product
struct Product: Codable {
    let productId : String
    let imageId: String
    let name: String
    let price: String
    let location: String
}

// MARK: - MainCategoryMenu
struct MainCategoryMenu {
    let image: String
    let name: String
}
