//
//  BaseTargert.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/20.
//

import Foundation
import Moya

/**
 * - Description: API  호출하기 위한 Base 타입
 * `AccessTokenAuthorizable`을 추가해줌으로서 헤더에 토큰 추가 (Authzoriton)
 */
protocol BaseTarget: TargetType, AccessTokenAuthorizable {}

extension BaseTarget {
    // API endpoint (개발, 운영 분리예정)
    var baseURL: URL {
        return URL(string: "https://development.api.avocadojapan.com")!
    }
    
    // HTTP 통신 시 헤더정보, 기본적으로 application/json의 Content-Type을 가짐
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    // HTTP 통신 시, 헤더에 들어갈 Authzorition 타입 기본적으로 bearer형식을 이용
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
