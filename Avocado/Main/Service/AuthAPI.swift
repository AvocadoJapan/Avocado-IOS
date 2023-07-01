//
//  AuthAPI.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/28.
//

import Foundation
import Moya

enum AuthAPI {
    case profile
    case signUp(name:String, regionId: Int)
    case changeAvatar(name:String, regionId: Int)
    case region(searchkeyword: String)
}

extension AuthAPI: BaseTarget {
    var path: String {
        switch self {
        case .profile:
            return "/v1/profile)"
            
        case .signUp:
            return "/v1/sign-up"
            
        case .changeAvatar:
            return "/v1/change-avatar"
            
        case .region:
            return "/v1/regions"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .profile, .region:
            return .get
            
        case .changeAvatar, .signUp:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .profile:
            return .requestPlain
            
        case .signUp(let name, let regionId):
            return .requestJSONEncodable([
                "name" : name,
                "regionId": "\(regionId)"
            ])
            
        case .changeAvatar(let name, let regionId):
            return .requestJSONEncodable([
                "name": name,
                "regionId" : "\(regionId)"
            ])
            
        case .region(let searchKeyword):
            return .requestParameters(parameters: [
                "search-keyword": searchKeyword
            ], encoding: JSONEncoding())
        }
    }
    
    
}
