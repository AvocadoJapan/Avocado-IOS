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

/**
 * - Description 공통적으로 사용되는 모델 enum ()
 */
enum CommonModel {
    /**
     * - Description S3에 업로드될 URL
     * - `url`값은 pre-signedURL으로 해당 값으로 이미지를 업로드함
     */
    struct S3UploadedURL: Codable {
        let url: String
    }
}
