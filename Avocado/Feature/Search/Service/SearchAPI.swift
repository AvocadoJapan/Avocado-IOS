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
}
