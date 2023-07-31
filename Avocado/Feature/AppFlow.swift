//
//  AppFlow.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/30.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxRelay
import RxCocoa
import Then

final class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? AppStep else { return .none }
        
        switch step {
            
        case .appIsStarted:
            return navigateToSplashFlow()
        case .mainIsRequired:
            return navigateToMainFlow()
        case .userLogout:
            return .none
        case .userAccountDelete:
            return .none
        case .errorOccurred(error: let error):
            return errorTrigger(error: error)
        }
    }
    
    private func navigateToSplashFlow() -> FlowContributors {
        let splashFlow = SplashFlow(root: self.rootViewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: splashFlow, withNextStepper: OneStepper(withSingleStep: SplashStep.splashIsRequired)))
    }
    
    private func navigateToAuthFlow() -> FlowContributors {
        let authFlow = AuthFlow(root: self.rootViewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: authFlow, withNextStepper: OneStepper(withSingleStep: AuthStep.loginIsRequired)))
    }
    
    private func navigateToMainFlow() -> FlowContributors {
        let mainFlow = AuthFlow(root: self.rootViewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: mainFlow, withNextStepper: OneStepper(withSingleStep: MainStep.errorOccurred(error: .unknown(-10, "정의되어있지않은 플로우입니다. 추가개발필요.")))))
    }
    
    private func errorTrigger(error: NetworkError) -> FlowContributors {
        let splashFlow = SplashFlow(root: self.rootViewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: splashFlow, withNextStepper: OneStepper(withSingleStep: SplashStep.errorOccurred(error: error))))
    }
}
