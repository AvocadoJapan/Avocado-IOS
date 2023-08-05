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
            return navigateToMainScreen()
        case .signUpIsRequired:
            return navigateToSignupScreen()
        case.profileIsRequired:
            return navigateToProfileSettingScreen()
        default :
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
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToLoginScreen() -> FlowContributors {
        let service = AuthService()
        let viewModel = LoginVM(service: service)
        let viewController = LoginVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToSignupScreen() -> FlowContributors {
        let service = AuthService()
        let viewModel = SignUpVM(service: service)
        let viewController = SignupVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
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
        let service = AuthService()
        let s3Service = S3Service()
        let viewModel = ProfileSettingVM(service: service, s3Service: s3Service)
        let viewController = ProfileSettingVC(vm: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToMainScreen() -> FlowContributors {
        // flow 설정 { 현재 네비게이션을 루트 컨트롤러로 설정함 }
        let flow = MainFlow(root: self.rootViewController)
        
        // 페이지 이동
        let nextStep = OneStepper(withSingleStep: MainStep.errorOccurred(error: .unknown(-10, "성공적으로 MainStep에 도달했음. 추가개발필요.")))
        
        return .one(flowContributor: .contribute(withNextPresentable: flow, withNextStepper: nextStep))
    }
    
    private func navigateToSplashScreen() -> FlowContributors {
        let viewModel = SplashVM(service: AuthService())
        let viewController = SplashVC(viewModel: viewModel)
        
        rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
}
