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
    
    private var rootViewController = BaseNavigationVC()
    
    init(root: BaseNavigationVC) {
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
        case .loginIsComplete(let user):
            return navigateToMainScreen(user: user)
        case .signUpIsRequired:
            return navigateToSignupScreen()
        case .profileIsRequired:
            return navigateToProfileSettingScreen()
        case .emailCheckIsRequired(let email, let password):
            return navigateToEmailCheckScreen(email: email, password: password)
        case .otherEmailIsRequired(let oldEmail):
            return navigateToOtherEmailScreen(email: oldEmail)
        case .regionIsRequired:
            return navigateToRegionSettingScreen()
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
    
    private func navigateToEmailCheckScreen(email: String, password: String) -> FlowContributors {
        
        let service = AuthService()
        let viewModel = EmailCheckVM(service: service,
                                        email: email,
                                        password: password)
        let viewController = EmailCheckVC(viewModel: viewModel)
        // 이메일 체크 화면에서도 화면이동이 필요한 경우가 있기 떄문에 navigation 설정
        let navigationController = BaseNavigationVC(rootViewController: viewController)
        
        rootViewController.present(navigationController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToOtherEmailScreen(email: String) -> FlowContributors {
        let service = AuthService()
        let viewModel = OtherEmailVM(service: service,
                                     oldEmail: email)
        
        let viewController = OtherEmailVC(viewModel: viewModel)
        
        let navigationController = BaseNavigationVC(rootViewController: viewController)
        
        if let presentedViewController = rootViewController.presentedViewController {
            presentedViewController.present(navigationController, animated: true)
        }
        else {
            rootViewController.present(navigationController, animated: true)
        }
        
        return .one(flowContributor: .contribute(withNext: viewController))
        
    }
    
    private func navigateToRegionSettingScreen() -> FlowContributors {
        
        let service = AuthService()
        let viewModel = RegionSettingVM(service: service)
        let viewController = RegionSettingVC(viewModel: viewModel)
        let navigationController = BaseNavigationVC(rootViewController: viewController)
        
        // 사용자 설정 플로우에서는 뒤로 돌아갈 수 없으므로 present
        if let emailCheckVC = rootViewController.presentedViewController {
            emailCheckVC.dismiss(animated: true, completion: {
                self.rootViewController.present(navigationController, animated: true)
            })
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToProfileSettingScreen() -> FlowContributors {
        let service = AuthService()
        let s3Service = S3Service()
        let viewModel = ProfileSettingVM(service: service, s3Service: s3Service)
        let viewController = ProfileSettingVC(vm: viewModel)
        
        if let navigationController = rootViewController.presentedViewController as? BaseNavigationVC {
            navigationController.pushViewController(viewController, animated: true)
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToMainScreen(user: User) -> FlowContributors {
        // flow 설정 { 현재 네비게이션을 루트 컨트롤러로 설정함 }
        let flow = MainFlow(root: rootViewController)
        
        //FIXME: 기존 authFlow의 네비게이션이 메인플로우와 동일할 필요가 없음 해당내용 개선 필요 {논의 필요}
        if let navigationController = rootViewController.presentedViewController as? BaseNavigationVC {
            navigationController.dismiss(animated: false)
        }
        
        // 페이지 이동
        let nextStep = OneStepper(withSingleStep: MainStep.mainIsRequired)
        
        return .one(flowContributor: .contribute(withNextPresentable: flow, withNextStepper: nextStep))
    }
    
    private func navigateToSplashScreen() -> FlowContributors {
        let viewModel = SplashVM(service: AuthService())
        let viewController = SplashVC(viewModel: viewModel)
        
        rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
}
