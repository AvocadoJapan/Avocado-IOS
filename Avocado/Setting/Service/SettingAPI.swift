//
//  AuthAPI.swift
//  Avocado
//
//  Created by NUNU:D on 2023/07/06.
//

import Foundation
import Moya

enum SettingAPI {
    case auth(provider: String, callback: String)
}

extension SettingAPI: BaseTarget {
    var path: String {
        switch self {
        case .auth:
            return "/v1/auth"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .auth:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .auth(let provider, let callback):
            return .requestParameters(parameters: [
                "provider": provider,
                "redirectUri": callback
            ], encoding: JSONEncoding())
        }
    }
    
    
}
