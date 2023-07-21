//
//  MainVM.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import Foundation
import RxSwift
import RxRelay
/**
 *## 클래스 설명: 메인화면에 대한 ViewModel을 구성, `sectionData`란 Observable을 이용하여 Main화면에 대한 정보를 변경해줌
 */
final class MainVM {
    
    
    public lazy var sectionData = BehaviorRelay<[SectionOfMainData]>(value: [
        
        SectionOfMainData(items: [
            .banner(data: Banner(imageURL: "https://www.google.com")),
            .banner(data: Banner(imageURL: "https://www.google.com")),
            .banner(data: Banner(imageURL: "https://www.google.com"))
        ]),
        
        SectionOfMainData(items: [
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Apple")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Camera")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Closet")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Shoe")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Machine")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Computer")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "Samsung")),
            .category(data: MainCategory(categoryImage: "person.crop.circle", categoryName: "More"))
        ]),
        
        SectionOfMainData(items: [
            .product(data: Product(imageURL: "", name: "AirPod Pro2", price: "3000000￥", location: "東京都渋谷区")),
            .product(data: Product(imageURL: "", name: "AirPod Pro2", price: "3000000￥", location: "東京都渋谷区1")),
            .product(data: Product(imageURL: "", name: "AirPod Pro2", price: "3000000￥", location: "東京都渋谷区2")),
            .product(data: Product(imageURL: "", name: "AirPod Pro2", price: "3000000￥", location: "東京都渋谷区3")),
            .product(data: Product(imageURL: "", name: "AirPod Pro2", price: "3000000￥", location: "東京都渋谷区4")),
            .product(data: Product(imageURL: "", name: "AirPod Pro2", price: "3000000￥", location: "東京都渋谷区5")),
        ], title: "もふもふの\nお友達"),
        
        SectionOfMainData(items: [
            .product(data: Product(imageURL: "", name: "Panasonic", price: "500000￥", location: "東京都足立区")),
            .product(data: Product(imageURL: "", name: "Panasonic1", price: "500000￥", location: "東京都足立区1")),
            .product(data: Product(imageURL: "", name: "Panasonic2", price: "500000￥", location: "東京都渋谷区2")),
            .product(data: Product(imageURL: "", name: "Panasonic3", price: "500000￥", location: "東京都渋谷区3")),
            .product(data: Product(imageURL: "", name: "Panasonic4", price: "500000￥", location: "東京都渋谷区4")),
            .product(data: Product(imageURL: "", name: "Panasonic5", price: "500000￥", location: "東京都渋谷区5")),
        ], title: "もふもふの\nお友達2"),
        
        SectionOfMainData(items: [
            .product(data: Product(imageURL: "", name: "Google Home", price: "303000￥", location: "東京都渋谷区")),
            .product(data: Product(imageURL: "", name: "Google Home", price: "303000￥", location: "東京都渋谷区1")),
            .product(data: Product(imageURL: "", name: "Google Home", price: "303000￥", location: "東京都渋谷区2")),
            .product(data: Product(imageURL: "", name: "Google Home", price: "303000￥", location: "東京都渋谷区3")),
            .product(data: Product(imageURL: "", name: "Google Home", price: "303000￥", location: "東京都渋谷区4")),
            .product(data: Product(imageURL: "", name: "Google Home", price: "303000￥", location: "東京都渋谷区5")),
        ], title: "もふもふの\nお友達3"),
    ])
    
    public let currentBannerPage = BehaviorRelay<Int>(value: 0) // 현재 배너페이지에 대한 Observable
    
}
