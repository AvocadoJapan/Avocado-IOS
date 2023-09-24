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
    case emailCheckIsRequired
    case passwordIsRequired
    case newPasswordIsRequired
    case doneIsRequired
    case contactIsRequired
    
    case errorOccurred(error: NetworkError)
}
