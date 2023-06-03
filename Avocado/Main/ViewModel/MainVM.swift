//
//  MainVM.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import Foundation
import RxSwift
import RxRelay

struct MainVM {
    private let mainDataOb = BehaviorRelay<MainData>(value: MainData(bannerList: [], recommandProductList: [], friendProductList: [], fruitProductList: []))
    
    lazy var bannerList = mainDataOb.map { $0.bannerList }
    lazy var recomamandProductList = mainDataOb.map { $0.recommandProductList }
    lazy var friendProductList = mainDataOb.map { $0.friendProductList }
    lazy var fruitProductList = mainDataOb.map { $0.fruitProductList }
    
    public let sectionData = BehaviorRelay<[SectionOfMainData]>(value: [
        
        SectionOfMainData(items: [
            .banner(data: Banner(imageURL: "https://www.google.com")),
            .banner(data: Banner(imageURL: "https://www.google.com")),
            .banner(data: Banner(imageURL: "https://www.google.com"))
        ]),
        
        SectionOfMainData(items: [
            .category(data: MainCategory(categoryImage: "", categoryName: "")),
            .category(data: MainCategory(categoryImage: "", categoryName: "")),
            .category(data: MainCategory(categoryImage: "", categoryName: "")),
            .category(data: MainCategory(categoryImage: "", categoryName: "")),
            .category(data: MainCategory(categoryImage: "", categoryName: "")),
            .category(data: MainCategory(categoryImage: "", categoryName: "")),
            .category(data: MainCategory(categoryImage: "", categoryName: "")),
            .category(data: MainCategory(categoryImage: "", categoryName: ""))
        ]),
        
        SectionOfMainData(items: [
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
        ]),
        
        SectionOfMainData(items: [
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
        ]),
        
        SectionOfMainData(items: [
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
            .product(data: Product(imageURL: "", name: "", price: "", location: "")),
        ]),
    ])
    
}
