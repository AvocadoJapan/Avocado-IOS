//
//  Constant.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/04.
//


/**
 - Description: 유저가 직접 볼수 없는 상수를 Constant로 분리 (ex. Url, Cell identifier ...)
 */
import Foundation

/**
 - Description: API URL을 모아둔 enum
 */
enum API {
    static let BASE_URL = "https://api.avocadojapan.com"
}
/**
 - Description: 소셜 로그인 타입
 */
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
/**
 * - description UserDefault 키 정보 값 세부 정보는 enum으로 분류
 */
enum UserDefaultsKey {
    enum Auth {
        static let notConfirmedUserID = "userNotConfirmedId"
    }
}



