//
//  EnumCountable+Protocol.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/21.
//

import Foundation

/**
 - Description: Enum 의 케이스를 셀 수 있게하는 extension
 */
protocol CaseCountable: CaseIterable {
    static var count: Int { get }
}

extension CaseCountable {
    static var count: Int {
        return Self.allCases.count
    }
}
