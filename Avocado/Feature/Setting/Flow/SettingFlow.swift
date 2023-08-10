//
//  SettingFlow.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/31.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxRelay
import RxCocoa
import Then

// 플로우는 화면 흐름 이벤트가 들어오면 로직처리 및 의존성 주입
final class SettingFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    init(root: UINavigationController) {
        self.rootViewController = root
        Logger.d("Setting init")
    }
    
    private var rootViewController = UINavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? SplashStep else { return .none }
        
        switch step {
        
        case .splashIsRequired:
            return navigateToSplashScreen()
        case .tokenIsRequired:
            return navigateToWelcomeScreen()
        case .tokenIsExist:
            return navigateToMainScreen()
        case .errorOccurred(let error):
            return navigateToFailScreen(with: error)
        }
    }
    
    private func navigateToSplashScreen() -> FlowContributors {
        let service = AuthService()
        let viewModel = SplashVM(service: service)
        let viewController = SplashVC(viewModel: viewModel)
        rootViewController.pushViewController(viewController, animated: false)
        
//        rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToWelcomeScreen() -> FlowContributors {
        // flow 설정 { 현재 네비게이션을 루트 컨트롤러로 설정함 }
        let flow = AuthFlow(root: self.rootViewController)
        // welcome 페이지 이동
        let nextStep = OneStepper(withSingleStep: AuthStep.welcomeIsRequired)
        
        return .one(flowContributor: .contribute(withNextPresentable: flow, withNextStepper: nextStep))
    }
    
    // FIXME: 추후 메인 MainVM을 Stepper로 개발후 return값 변경해야됨
    private func navigateToMainScreen() -> FlowContributors {
        let viewModel = MainVM()
        let viewController = MainVC(viewModel: viewModel)
        
        rootViewController.setViewControllers([viewController], animated: true)
        return .one(flowContributor: .contribute(withNext: viewController))
    }

    private func navigateToFailScreen(with error: NetworkError) -> FlowContributors {
        
        let viewController = FailVC(error: error)
        
        // 스무스 애니메이션 적용
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        rootViewController.view.layer.add(transition, forKey: kCATransition)
        
        rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(flowContributor: .contribute(withNext: viewController))
    }
}

