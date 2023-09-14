//
//  SearchResultModel.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/14.
//

import Foundation

struct SearchResult: Decodable {
    let products: [Product]
    let category: [String]
}
