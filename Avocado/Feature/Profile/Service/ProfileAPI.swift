//
//  ProfileAPI.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import Foundation
import Moya

enum ProfileAPI {
    case userProfile
}

extension ProfileAPI: BaseTarget {
    var path: String {
        switch self {
        case .userProfile: return "v1/profile/userPage"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .userProfile: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .userProfile: return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .userProfile:
            return """
            {
                "user":{
                    "id":"UUID",
                    "name":"AvocadoDemo",
                    "accounts":{
                        "cognito":"string"
                    },
                    "createdAt":1693302608,
                    "updatedAt":12345678,
                    "avatar":{
                        "imageId":"ImageID",
                        "changedAt":12345678
                    }
                },
                "sellProduct":[
                    {
                        "productId":"random-uuid-13",
                        "mainImageId":"random-uuid-14",
                        "imageIds":[
                            "sample9",
                            "sample10"
                        ],
                        "name":"맥북 프로 14인치 32기가 CTO모델",
                        "price":"1,120,000원",
                        "location":"구로구 신도림동"
                    },
                    {
                        "productId":"random-uuid-15",
                        "mainImageId":"random-uuid-16",
                        "imageIds":[
                            "sample11",
                            "sample12"
                        ],
                        "name":"아이폰 13프로",
                        "price":"680,000원",
                        "location":"양천구 목2동"
                    },
                    {
                        "productId":"random-uuid-17",
                        "mainImageId":"random-uuid-18",
                        "imageIds":[
                            "sample13",
                            "sample14"
                        ],
                        "name":"아이폰 12프로 급처",
                        "price":"540,000원",
                        "location":"강남구 대치1동"
                    },
                    {
                        "productId":"random-uuid-19",
                        "mainImageId":"random-uuid-20",
                        "imageIds":[
                            "sample15",
                            "sample16"
                        ],
                        "name":"아이패드 프로 128기가 3세대",
                        "price":"820,000원",
                        "location":"강남구 대치2동"
                    },
                    {
                        "productId":"random-uuid-21",
                        "mainImageId":"random-uuid-22",
                        "imageIds":[
                            "sample17",
                            "sample18"
                        ],
                        "name":"아이팟 클래식 새제품 미개봉",
                        "price":"80,000원",
                        "location":"강남구 청담동"
                    },
                    {
                        "productId":"random-uuid-23",
                        "mainImageId":"random-uuid-24",
                        "imageIds":[
                            "sample19",
                            "sample20"
                        ],
                        "name":"맥북 에어 13인치 M2 영문자판",
                        "price":"800,000원",
                        "location":"서초구 반포1동"
                    }
                ],
                "buyProduct":[
                    {
                        "productId":"random-uuid-25",
                        "mainImageId":"random-uuid-26",
                        "imageIds":[
                            "sample21",
                            "sample22"
                        ],
                        "name":"태그호이어 칼레라 오토매틱 시계",
                        "price":"770,000원",
                        "location":"서울시 중량구"
                    },
                    {
                        "productId":"random-uuid-27",
                        "mainImageId":"random-uuid-28",
                        "imageIds":[
                            "sample23",
                            "sample24"
                        ],
                        "name":"까르띠에 파샤 오토매틱 시계",
                        "price":"2,300,000원",
                        "location":"지역정보 없음"
                    },
                    {
                        "productId":"random-uuid-29",
                        "mainImageId":"random-uuid-30",
                        "imageIds":[
                            "sample25",
                            "sample26"
                        ],
                        "name":"까르띠에 발롱블루 42미리 자동시계",
                        "price":"4,020,000원",
                        "location":"송파구 마천2동"
                    },
                    {
                        "productId":"random-uuid-31",
                        "mainImageId":"random-uuid-32",
                        "imageIds":[
                            "sample27",
                            "sample28"
                        ],
                        "name":"카시오 커스텀 시계",
                        "price":"195,000원",
                        "location":"인천시 미추홀구"
                    },
                    {
                        "productId":"random-uuid-33",
                        "mainImageId":"random-uuid-34",
                        "imageIds":[
                            "sample1",
                            "sample2"
                        ],
                        "name":"국정원 절대시계",
                        "price":"102,000원",
                        "location":"강동구 상일동"
                    },
                    {
                        "productId":"random-uuid-35",
                        "mainImageId":"random-uuid-36",
                        "imageIds":[
                            "sample29",
                            "sample30"
                        ],
                        "name":"오메가 씨마스터 새제품급",
                        "price":"7,300,500원",
                        "location":"동작구 대방동"
                    }
                ]
            }
            """.data(using: .utf8)!
        }
    }
    
    
}
