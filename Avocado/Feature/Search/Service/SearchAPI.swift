//
//  SearchAPI.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/09.
//

import Foundation
import Moya

enum SearchAPI {
    case searchResult(keyword: String)
}

extension SearchAPI: BaseTarget {
    var path: String {
        switch self {
        case .searchResult(let keyword): return "v1/search?keyword=\(keyword)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchResult: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchResult: return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .searchResult:
            return """
            {
                "products":[
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
                "category":[
                    "아이폰 12 프로 맥스",
                    "모니터",
                    "iphone11",
                    "필립스 휴 모니터 32인치 무상 수리",
                ]
            }
            
            """.data(using: .utf8)!
        }
    }
    
}
