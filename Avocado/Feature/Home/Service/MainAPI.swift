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
        switch self {
        case .main:
            return
                    """
                      {
                        "userID": "d2e4ec3d-c876-4e29-b6b9-1a78a1a8f012",
                        "bannerList": [
                          {
                            "id": "5ad4921b-42d8-4e5d-a7f5-de763617c7eb",
                            "name": "여름 세일",
                            "image": "random-uuid-1"
                          },
                          {
                            "id": "45826ad0-834f-447f-b19b-ac0331e367e2",
                            "name": "겨울 컬렉션",
                            "image": "random-uuid-2"
                          }
                        ],
                        "productSection": [
                          {
                            "id": "05c6501c-7ff6-4c95-9ecd-28834b2a1279",
                            "name": "최근 본 상품",
                            "products": [
                              {
                                "productId": "random-uuid-1",
                                "mainImageId": "random-uuid-2",
                                "imageIds": ["sample1", "sample2"],
                                "name": "Macbook pro M2",
                                "price": "180,000원",
                                "location": "지역정보 없음"
                              },
                              {
                                "productId": "random-uuid-3",
                                "mainImageId": "random-uuid-4",
                                "imageIds": ["sample3", "sample4"],
                                "name": "Airpods Max",
                                "price": "50,000원",
                                "location": "지역정보 없음"
                              },
                              {
                                "productId": "random-uuid-5",
                                "mainImageId": "random-uuid-6",
                                "imageIds": ["sample5", "sample6"],
                                "name": "아이폰 14pro",
                                "price": "50,000원",
                                "location": "강북구 미아동"
                              },
                              {
                                "productId": "random-uuid-7",
                                "mainImageId": "random-uuid-8",
                                "imageIds": ["sample1", "sample2"],
                                "name": "아이패드 프로 12.9인치 2022년형",
                                "price": "890,000원",
                                "location": "동대문구 제기동"
                              },
                              {
                                "productId": "random-uuid-9",
                                "mainImageId": "random-uuid-10",
                                "imageIds": ["sample7", "sample8"],
                                "name": "소니 카메라",
                                "price": "500,000원",
                                "location": "강북구 미아동"
                              },
                              {
                                "productId": "random-uuid-11",
                                "mainImageId": "random-uuid-12",
                                "imageIds": ["sample1", "sample2"],
                                "name": "브라이틀링 콜트 오토메틱 시계",
                                "price": "170,000원",
                                "location": "마포구 신수동"
                              }
                            ]
                          },
                          {
                            "id": "f261ca49-a07c-4eab-a417-c2233ec3ff65",
                            "name": "내 주변 인기 상품",
                            "products": [
                              {
                                "productId": "random-uuid-13",
                                "mainImageId": "random-uuid-14",
                                "imageIds": ["sample9", "sample10"],
                                "name": "초소형 믹서기",
                                "price": "1,120,000원",
                                "location": "구로구 신도림동"
                              },
                              {
                                "productId": "random-uuid-15",
                                "mainImageId": "random-uuid-16",
                                "imageIds": ["sample11", "sample12"],
                                "name": "다이슨 청소기",
                                "price": "299,000원",
                                "location": "양천구 목2동"
                              },
                              {
                                "productId": "random-uuid-17",
                                "mainImageId": "random-uuid-18",
                                "imageIds": ["sample13", "sample14"],
                                "name": "나이키 범고래 신발",
                                "price": "110,000원",
                                "location": "강남구 대치1동"
                              },
                              {
                                "productId": "random-uuid-19",
                                "mainImageId": "random-uuid-20",
                                "imageIds": ["sample15", "sample16"],
                                "name": "샤오미 가습기",
                                "price": "134,000원",
                                "location": "강남구 대치2동"
                              },
                              {
                                "productId": "random-uuid-21",
                                "mainImageId": "random-uuid-22",
                                "imageIds": ["sample17", "sample18"],
                                "name": "비스포크 냉장고",
                                "price": "990,000원",
                                "location": "강남구 청담동"
                              },
                              {
                                "productId": "random-uuid-23",
                                "mainImageId": "random-uuid-24",
                                "imageIds": ["sample19", "sample20"],
                                "name": "닌텐도 스위치",
                                "price": "415,000원",
                                "location": "서초구 반포1동"
                              }
                            ]
                          },
                          {
                            "id": "f261ca49-a07c-4eab-a417-c2233ec3ff65",
                            "name": "애플 제품 모음전",
                            "products": [
                              {
                                "productId": "random-uuid-13",
                                "mainImageId": "random-uuid-14",
                                "imageIds": ["sample9", "sample10"],
                                "name": "맥북 프로 14인치 32기가 CTO모델",
                                "price": "1,120,000원",
                                "location": "구로구 신도림동"
                              },
                              {
                                "productId": "random-uuid-15",
                                "mainImageId": "random-uuid-16",
                                "imageIds": ["sample11", "sample12"],
                                "name": "아이폰 13프로",
                                "price": "680,000원",
                                "location": "양천구 목2동"
                              },
                              {
                                "productId": "random-uuid-17",
                                "mainImageId": "random-uuid-18",
                                "imageIds": ["sample13", "sample14"],
                                "name": "아이폰 12프로 급처",
                                "price": "540,000원",
                                "location": "강남구 대치1동"
                              },
                              {
                                "productId": "random-uuid-19",
                                "mainImageId": "random-uuid-20",
                                "imageIds": ["sample15", "sample16"],
                                "name": "아이패드 프로 128기가 3세대",
                                "price": "820,000원",
                                "location": "강남구 대치2동"
                              },
                              {
                                "productId": "random-uuid-21",
                                "mainImageId": "random-uuid-22",
                                "imageIds": ["sample17", "sample18"],
                                "name": "아이팟 클래식 새제품 미개봉",
                                "price": "80,000원",
                                "location": "강남구 청담동"
                              },
                              {
                                "productId": "random-uuid-23",
                                "mainImageId": "random-uuid-24",
                                "imageIds": ["sample19", "sample20"],
                                "name": "맥북 에어 13인치 M2 영문자판",
                                "price": "800,000원",
                                "location": "서초구 반포1동"
                              }
                            ]
                          },
                          {
                            "id": "c64def65-0a29-453f-b601-9669a95bde1e",
                            "name": "나만없어! 시계모음",
                            "products": [
                              {
                                "productId": "random-uuid-25",
                                "mainImageId": "random-uuid-26",
                                "imageIds": ["sample21", "sample22"],
                                "name": "태그호이어 칼레라 오토매틱 시계",
                                "price": "770,000원",
                                "location": "서울시 중량구"
                              },
                              {
                                "productId": "random-uuid-27",
                                "mainImageId": "random-uuid-28",
                                "imageIds": ["sample23", "sample24"],
                                "name": "까르띠에 파샤 오토매틱 시계",
                                "price": "2,300,000원",
                                "location": "지역정보 없음"
                              },
                              {
                                "productId": "random-uuid-29",
                                "mainImageId": "random-uuid-30",
                                "imageIds": ["sample25", "sample26"],
                                "name": "까르띠에 발롱블루 42미리 자동시계",
                                "price": "4,020,000원",
                                "location": "송파구 마천2동"
                              },
                              {
                                "productId": "random-uuid-31",
                                "mainImageId": "random-uuid-32",
                                "imageIds": ["sample27", "sample28"],
                                "name": "카시오 커스텀 시계",
                                "price": "195,000원",
                                "location": "인천시 미추홀구"
                              },
                              {
                                "productId": "random-uuid-33",
                                "mainImageId": "random-uuid-34",
                                "imageIds": ["sample1", "sample2"],
                                "name": "국정원 절대시계",
                                "price": "102,000원",
                                "location": "강동구 상일동"
                              },
                              {
                                "productId": "random-uuid-35",
                                "mainImageId": "random-uuid-36",
                                "imageIds": ["sample29", "sample30"],
                                "name": "오메가 씨마스터 새제품급",
                                "price": "7,300,500원",
                                "location": "동작구 대방동"
                              }
                            ]
                          }
                        ]
                      }
                    """.data(using: .utf8)!
        case .event, .product:
            return "".data(using: .utf8)!
        }
    }
    
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
