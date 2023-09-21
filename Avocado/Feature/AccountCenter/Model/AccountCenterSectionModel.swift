//
//  AccountCenterSectionModel.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/20.
//

import Foundation
import Differentiator

/**
 * - Description 계정센터 정적 데이터 모델
 */
struct AccountCenterData {
    let type: AccountCenterDataType
    
    init(type: AccountCenterDataType) {
        self.type = type
    }
}

/**
 * - Description RxDataSource를 이용하기 위한  아이템
 */
struct AccountCenterDataSection {
    var items: [AccountCenterData]
}

extension AccountCenterDataSection: SectionModelType {
    typealias Item = AccountCenterData
    
    init(original: AccountCenterDataSection, items: [AccountCenterData]) {
        self = original
        self.items = items
    }
}
