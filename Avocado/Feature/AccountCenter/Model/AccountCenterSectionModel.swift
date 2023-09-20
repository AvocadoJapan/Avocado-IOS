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
    let title: String // 제목
    let type: SettingType // 설정 타입
    
    init(title: String, type: SettingType) {
        self.title = title
        self.type = type
    }
}
/**
 * - Description 계정센터 타입 정보 셀에 대한 행동 정보를 담음
 */
enum AccountCenterDataType {
    case findEmail
    case findPassword
    
    case accountLocked
    case confirmCodeUnvalid
    
    case contactCustomerCenter
    case accountHacked
    case accountDelete
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
