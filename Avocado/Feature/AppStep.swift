//
//  AppStep.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/30.
//

import RxFlow
import Foundation
import RxRelay
import RxSwift


@frozen enum AppStep: Step {
    
    // 화면별
    case appIsStarted
    case mainIsRequired
    
    // 상황별
    case userLogout
    case userAccountDelete
    case errorOccurred(error: NetworkError)
}
