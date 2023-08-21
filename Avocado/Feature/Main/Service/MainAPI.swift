//
//  MainAPI.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/21.
//

import Foundation
import Moya

enum MainAPI {
    case main
    case product(id: String)
    case event
}

extension MainAPI: BaseTarget {
    
    var path: String {
        switch self {
        case .main: return "/v1/main"
        case .product(let id): return "/v1/product/\(id)"
        case .event: return "/v1/event"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .main, .product, .event:
            return .get
        }
    }
    
    var sampleData: Data {
        """
           {
             "userID": "d2e4ec3d-c876-4e29-b6b9-1a78a1a8f012",
             "bannerList": [
               {"id": "5ad4921b-42d8-4e5d-a7f5-de763617c7eb", "name": "여름 세일", "random-uuid-1"},
               {"id": "45826ad0-834f-447f-b19b-ac0331e367e2", "name": "겨울 컬렉션", "random-uuid-1"}
             ],
             "productSection": [
               {
                 "id": "05c6501c-7ff6-4c95-9ecd-28834b2a1279",
                 "name": "최근 본 상품과 비슷해요",
                 "products": [
                   {"productId": "random-uuid-1", "imageId": "random-uuid-2", "name": "맥북 프로 M2Pro 14인치 기본형", "price": "1,700,000원", "location": "서울시 종로구"},
                   {"productId": "random-uuid-3", "imageId": "random-uuid-4", "name": "에어팟 맥스", "price": "550,000원", "location": "서울시 노원구"},
                   {"productId": "random-uuid-5", "imageId": "random-uuid-6", "name": "아이폰 12프로 기본형", "price": "800,000원", "location": "서울시 영등포구"},
                   {"productId": "random-uuid-7", "imageId": "random-uuid-8", "name": "아이패드 프로 12.9인치 2022년형", "price": "890,000원", "location": "서울시 서초구"},
                   {"productId": "random-uuid-9", "imageId": "random-uuid-10", "name": "소니 카메라", "price": "500,000원", "location": "서울시 강남구"},
                   {"productId": "random-uuid-11", "imageId": "random-uuid-12", "name": "브라이틀링 콜트 오토메틱 시계", "price": "170,000원", "location": "서울시 중량구"}
                 ]
               },
               {
                 "id": "f261ca49-a07c-4eab-a417-c2233ec3ff65",
                 "name": "애플 인기 상품",
                 "products": [
                   {"productId": "random-uuid-13", "imageId": "random-uuid-14", "name": "맥북 프로 14인치 32기가 CTO모델", "price": "1,120,000원", "location": "서울시 종로구"},
                   {"productId": "random-uuid-15", "imageId": "random-uuid-16", "name": "아이폰 13프로", "price": "680,000원", "location": "부산"},
                   {"productId": "random-uuid-17", "imageId": "random-uuid-18", "name": "아이폰 12프로 급처", "price": "540,000원", "location": "서울"},
                   {"productId": "random-uuid-19", "imageId": "random-uuid-20", "name": "아이패드 프로 128기가 3세대", "price": "820,000원", "location": "인천"},
                   {"productId": "random-uuid-21", "imageId": "random-uuid-22", "name": "아이팟 클래식 새제품 미개봉", "price": "80,000원", "location": "대구"},
                   {"productId": "random-uuid-23", "imageId": "random-uuid-24", "name": "맥북 에어 13인치 M2 영문자판", "price": "800,000원", "location": "광주"}
                 ]
               },
               {
                 "id": "c64def65-0a29-453f-b601-9669a95bde1e",
                 "name": "나만없어! 시계모음",
                 "products": [
                   {"productId": "random-uuid-25", "imageId": "random-uuid-26", "name": "태그호이어 칼레라 오토매틱 시계", "price": "770,000원", "location": "서울시 중량구"},
                   {"productId": "random-uuid-27", "imageId": "random-uuid-28", "name": "까르띠에 파샤 오토매틱 시계", "price": "2,300,000원", "location": "지역정보 없음"},
                   {"productId": "random-uuid-29", "imageId": "random-uuid-30", "name": "까르띠에 발롱블루 42미리 자동시계", "price": "4,020,000원", "location": "서울시 강남구"},
                   {"productId": "random-uuid-31", "imageId": "random-uuid-32", "name": "카시오 커스텀 시계", "price": "195,000원", "location": "인천시 미추홀구"},
                   {"productId": "random-uuid-33", "imageId": "random-uuid-34", "name": "국정원 절대시계", "price": "102,000원", "location": "대구시 유성구"},
                   {"productId": "random-uuid-35", "imageId": "random-uuid-36", "name": "오메가 씨마스터 새제품급", "price": "7,300,500원", "location": "대전시 서구"}
                 ]
               }
             ]
           }
        """.data(using: .utf8)!}
    
    var task: Moya.Task {
        switch self {
        case .main:
            return .requestPlain
        case .product:
            return .requestPlain
        case .event:
            return .requestPlain
        }
    }
    
}
