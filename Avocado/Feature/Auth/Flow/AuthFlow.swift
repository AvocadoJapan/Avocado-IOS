//
//  AuthFlow.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/14.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxRelay
import RxCocoa
import Then

// 플로우는 화면 흐름 이벤트가 들어오면 로직처리 및 의존성 주입
final class AuthFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController = UINavigationController()
    
    init(root: UINavigationController) {
        self.rootViewController = root
        Logger.d("AuthFlow init")
    }
    
    deinit {
        Logger.d("AuthFlow deinit")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? AuthStep else { return .none }
        
        switch step {
        case .welcomeIsRequired:
            return navigateToWelcomScreen()
        case .loginIsRequired:
            return navigateToLoginScreen()
        case .loginIsComplete:
            return navigateToWelcomScreen()
        case .signUpIsRequired:
            return navigateToSignupScreen()
        case .signUpIsComplete:
            return navigateToEmailCheckScreen()
        case .socialLoginIsComplete:
            return navigateToWelcomScreen()
        case .emailCheckIsRequired:
            return navigateToEmailCheckScreen()
        case .emailCheckIsComplete:
            return navigateToRegionSettingScreen()
        case .otherEmailIsRequired:
            return navigateToOtherEmailScreen()
        case .otherEmailIsComplete:
            return navigateToEmailCheckScreen()
        case .regionIsRequired:
            return navigateToRegionSettingScreen()
        case .regionIsComplete:
            return navigateToProfileSettingScreen()
        case .profileIsRequired:
            return navigateToProfileSettingScreen()
        case .profileIsComplete:
            return navigateToWelcomScreen()
        default:
            return .none
        }
    }
    
    private func navigateToWelcomScreen() -> FlowContributors {
        let service = AuthService()
        let viewModel = WelcomeVM(service: service)
        let viewController = WelcomeVC(viewModel: viewModel)

        // 스무스 애니메이션 적용
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        rootViewController.view.layer.add(transition, forKey: kCATransition)

        // 커스텀 애니메이션 적용시 animated: false 로 설정
        rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(flowContributor: .contribute(withNext: viewController))
    }
    
    private func navigateToLoginScreen() -> FlowContributors {
        return .none
    }
    
    private func navigateToSignupScreen() -> FlowContributors {
        return .none
    }

    private func navigateToEmailCheckScreen() -> FlowContributors {
        return .none
    }
        
    private func navigateToOtherEmailScreen() -> FlowContributors {
        return .none
    }
    
    private func navigateToRegionSettingScreen() -> FlowContributors {
        return .none
    }
    
    private func navigateToProfileSettingScreen() -> FlowContributors {
        return .none
    }
        
    private func navigateToMainScreen() -> FlowContributors {
        return .none
    }
        
    private func navigateToSplashScreen() -> FlowContributors {
        let splashVM = SplashVM(service: AuthService())
        let splashVC = SplashVC(viewModel: splashVM)
        rootViewController.setViewControllers([splashVC], animated: false)
        return .one(flowContributor: .contribute(withNext: splashVC))
    }
}
