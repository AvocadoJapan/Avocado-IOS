//
//  Constant.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/04.
//

import Foundation

/**
 - Description: 자주 사용하는 상수를 Constant 로 분리해놓음 (ex. Url, Cell identifier ...)
 */
enum API {
    static let BASE_URL = "https://api.avocadojapan.com"
}

// Cell identifier
enum IDENTIFIER {
//    static let CAT_CV_CELL = "catCVCell"
//    static let BADGE_TV_CELL = "badgeTVCell"
//    static let STAR_LIST_TV_CELL = "starListTVCell"
}

enum SocialType {
    case google
    case apple
    
    var name: String {
        switch self {
        case .google:
            return "google"
        case .apple:
            return "apple"
        }
    }
}

/**
 * - Description 공통적으로 사용되는 모델 enum ()
 */
enum Common {
    /**
     * - Description response가 url 하나만 있는 경우의 CommonModel
     */
    struct SingleURL: Codable {
        let url: String
    }
    
    /**
     * - Description PresignedURL 데이터 정보 { 해당 값을 가지고 S3 버킷에 업로드 }
     */
    struct PresignedURLData: Codable {
        let id: String
        let url: String
        let fields: [String: String]
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case url = "url"
            case fields = "fields"
        }
    }

}
