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
    
    case accountCenterIsRequired
    
    case findEmailIsRequired
    case findPasswordIsRequired
    case accountLockedIsRequired
    case confirmCodeUnvalidIsRequired
    case code2FAUnvalidIsRequired
    case contactCustomerCenterIsRequired
    case accountHackedIsRequired
    case accountDeleteIsRequired
    
    case errorOccurred(error: NetworkError)
}
