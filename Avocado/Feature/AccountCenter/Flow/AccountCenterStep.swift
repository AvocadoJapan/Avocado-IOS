//
//  AccountCenterStep.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/20.
//

import RxFlow
import Foundation
import RxRelay
import RxSwift


@frozen enum AccountCenterStep: Step {
    // 초기화면 불러오기
    case accountCenterIsRequired
    
    // 초기화면 메뉴별
//    case findEmailIsRequired
//    case findPasswordIsRequired
//    case confirmCodeUnvalidIsRequired
//    case code2FAUnvalidIsRequired
//    case accountLockedIsRequired
//    case accountHackedIsRequired
//    case accountDeleteIsRequired
    
    // 각종 화면별
    case emailIsRequired(type: AccountCenterDataType)
    case emailCheckIsRequired(type: AccountCenterDataType)
    case passwordIsRequired(type: AccountCenterDataType, email: String)
    case newPasswordIsRequired(type: AccountCenterDataType)
    case doneIsRequired(type: AccountCenterDataType)
    case contactIsRequired(type: AccountCenterDataType)
    
    case errorOccurred(error: NetworkError)
}
