//
//  SplashFlow.swift
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
final class SplashFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    init(root: UINavigationController) {
        self.rootViewController = root
        Logger.d("SplashFlow init")
    }
    
    private var rootViewController = UINavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? SplashStep else { return .none }
        
        switch step {
        case .splashIsRequired:
            return navigateToSplashScreen()
        case .tokenIsRequired:
            return navigateToWelcomeScreen()
        case .tokenIsExist(let user):
            return navigateToMainScreen(user: user)
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
    
    private func navigateToMainScreen(user: User) -> FlowContributors {
        // flow 설정 { 현재 네비게이션을 루트 컨트롤러로 설정함 }
        let flow = MainFlow(root: self.rootViewController)
        
        // 페이지 이동
        let nextStep = OneStepper(withSingleStep: MainStep.mainIsRequired(user: user))
        
        return .one(flowContributor: .contribute(withNextPresentable: flow, withNextStepper: nextStep))
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
