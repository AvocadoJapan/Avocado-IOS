//
//  Regions.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/28.
//

import Foundation

struct Region: Codable {
    let regionId: Int
    let name: String
    
    enum CodingsKey: String, CodingKey {
        case regionId = "id"
        case name = "name"
    }
}

typealias Regions = [Region]
