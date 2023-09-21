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
    case appIsStarted   // 스플래시화면
    case mainIsRequired // 메인화면
    case authIsRequired // 인증화면
    case accountCenterIsRequired //계정센터 화면
    
    // 상황별
    case userLogout
    case userAccountDelete
    case errorOccurred(error: NetworkError)
}
