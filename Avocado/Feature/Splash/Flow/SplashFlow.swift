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
    
    private lazy var rootViewController = BaseNavigationVC().then {
        $0.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        Logger.i("deinit \(self)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? SplashStep else { return .none }
        
        switch step {
        case .splashIsRequired:
            return navigateToSplashScreen()
        case .tokenIsRequired:
            return .end(forwardToParentFlowWithStep: AppStep.authIsRequired)
        case .tokenIsExist:
            return .end(forwardToParentFlowWithStep: AppStep.mainIsRequired)
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
    
    private func navigateToFailScreen(with error: NetworkError) -> FlowContributors {
        
        let viewController = FailVC(error: error)
        
        // 스무스 애니메이션 적용
        rootViewController.view.fadeOut()
        rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(flowContributor: .contribute(withNext: viewController))
    }
}
