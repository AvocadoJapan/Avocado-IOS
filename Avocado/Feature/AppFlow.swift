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
        return self.window
    }
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        Logger.i("AppFlow init")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? AppStep else { return .none }
        
        switch step {
            
        case .appIsStarted:
            return navigateToSplashFlow() //스플래시 화면이동
        case .mainIsRequired:
            return navigateToMainFlow() // 메인화면이동
        case .authIsRequired:
            return navigateToAuthFlow() // 인증화면이동
            
        case .userLogout:
            return .none
        case .userAccountDelete:
            return .none
        case .errorOccurred(error: let error):
            return errorTrigger(error: error)
        }
    }
    
    /**
     * - description 스플래시 이동화면 플로우
     */
    private func navigateToSplashFlow() -> FlowContributors {
        let splashFlow = SplashFlow()
        
        Flows.use(splashFlow, when: .created) { [unowned self] root in
            self.window.rootViewController = root
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: splashFlow, withNextStepper: OneStepper(withSingleStep: SplashStep.splashIsRequired)))
    }
    
    /**
     * - description 인증화면 이동 플로우 함수
     */
    private func navigateToAuthFlow() -> FlowContributors {
        let authFlow = AuthFlow(root: BaseNavigationVC())
        
        Flows.use(authFlow, when: .created) { [unowned self] root in
            self.window.rootViewController = root
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: authFlow, withNextStepper: OneStepper(withSingleStep: AuthStep.welcomeIsRequired)))
    }
    
    /**
     * - description 메인화면 이동 플로우 함수
     */
    private func navigateToMainFlow() -> FlowContributors {
        let mainFlow = MainFlow(root: BaseNavigationVC())
        
        Flows.use(mainFlow, when: .created) { [unowned self] root in
            self.window.rootViewController = root
            UIView.transition(with: self.window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil)
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: mainFlow, withNextStepper: OneStepper(withSingleStep: MainStep.mainIsRequired)))
    }
    
    /**
     * - description 에러화면 이동 플로우 함수
     */
    private func errorTrigger(error: NetworkError) -> FlowContributors {
        let splashFlow = SplashFlow()
        
        Flows.use(splashFlow, when: .created) { [unowned self] root in
            self.window.rootViewController = root
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: splashFlow, withNextStepper: OneStepper(withSingleStep: SplashStep.errorOccurred(error: error))))
    }
}
