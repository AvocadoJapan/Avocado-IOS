//
//  MainAPI.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/21.
//

import Foundation
import Moya

enum MainAPI {
    case profile
}

extension MainAPI: BaseTarget {
    var path: String {
        switch self {
        case .profile:
            return "/v1/profile"
            
        case .signUp:
            return "/v1/sign-up"
            
        case .changeAvatar:
            return "/v1/profile/avatar"
            
        case .region:
            return "/v1/regions"
            
        case .uploadAvatar:
            return "/v1/images"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .profile, .region:
            return .get
            
        case .uploadAvatar, .signUp:
            return .post
            
        case .changeAvatar:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .profile:
            return .requestPlain
            
        case .signUp(let name, let regionId):
            return .requestJSONEncodable([
                "name" : name,
                "regionId": regionId
            ])
            
        case .changeAvatar(let imageId):
            return .requestJSONEncodable([
                "imageId": imageId,
            ])
            
        case .region(let searchKeyword, let depth):
            return .requestParameters(parameters: [
                "search-keyword": searchKeyword,
                "depth": depth
            ], encoding: URLEncoding.queryString)
            
        case .uploadAvatar(let type, let size):
            return .requestJSONEncodable([
                "type": type,
                "size": "\(size)"
            ])
        }
    }
}
