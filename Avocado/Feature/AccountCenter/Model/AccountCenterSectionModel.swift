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
    
    static func getDataList() -> [AccountCenterDataSection] {
        
        var sections : [AccountCenterDataSection] = []
        
        let findEmailSection = AccountCenterDataSection(title: "찾기 관련", items: [
            AccountCenterDataType.findEmail.getData(),
            AccountCenterDataType.findPassword.getData(),
        ])
        sections.append(findEmailSection)
        
        let unvalidSection = AccountCenterDataSection(title: "인증 관련", items: [
            AccountCenterDataType.confirmCodeUnvalid.getData(),
            AccountCenterDataType.code2FAUnvalid.getData(),
        ])
        sections.append(unvalidSection)
        
        let errorSection = AccountCenterDataSection(title: "에러 관련", items: [
            AccountCenterDataType.signInError.getData(),
            AccountCenterDataType.signUpError.getData(),
        ])
        sections.append(errorSection)
        
        let accountSection = AccountCenterDataSection(title: "계정지원 관련", items: [
            AccountCenterDataType.accountLocked.getData(),
            AccountCenterDataType.accountHacked.getData(),
            AccountCenterDataType.accountDelete.getData(),
        ])
        sections.append(accountSection)

        return sections
    }
}

/**
 * - Description RxDataSource를 이용하기 위한  아이템
 */
struct AccountCenterDataSection {
    var title: String
    var items: [AccountCenterData]
}

extension AccountCenterDataSection: SectionModelType {
    typealias Item = AccountCenterData
    
    init(original: AccountCenterDataSection, items: [AccountCenterData]) {
        self = original
        self.items = items
    }
}
