//
//  AccountCenterFlow.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/20.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxRelay
import RxCocoa
import Then

// 플로우는 화면 흐름 이벤트가 들어오면 로직처리 및 의존성 주입
final class AccountCenterFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    init(root: BaseNavigationVC) {
        self.rootViewController = root
        Logger.d("MainFlow init")
    }
    
    deinit {
        Logger.i("deinit \(self)")
    }
    
    private var rootViewController = BaseNavigationVC()
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? AccountCenterStep else { return .none }
        
        switch step {
        case .accountCenterIsRequired: return navigateToAccountCenterScreen()
            
        case .emailIsRequired(let type): return navigateToEmailScreen(type: type)
        case .emailCheckIsRequired: return navigateToEmailCheckScreen()
        case .passwordIsRequired: return navigateToPasswordScreen()
        case .newPasswordIsRequired: return navigateToNewPasswordScreen()
        case .doneIsRequired: return navigateToDoneScreen()
        case .contactIsRequired: return navigateToContactScreen()
            
        case .errorOccurred(let error): return .none

        }
    }
    
    private func navigateToAccountCenterScreen() -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = AccountCenterVM(service: service)
        let viewController = AccountCenterVC(viewModel: viewModel)
        
        // 스무스 애니메이션 적용
        rootViewController.view.fadeOut()
        // 커스텀 애니메이션 적용시 animated: false 로 설정
        rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToEmailScreen(type: AccountCenterDataType) -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = ACEmailVM(service: service)
        let viewController = ACEmailVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToEmailCheckScreen() -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = ACEmailCheckVM(service: service)
        let viewController = ACEmailCheckVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToPasswordScreen() -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = ACPasswordVM(service: service)
        let viewController = ACPasswordVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToNewPasswordScreen() -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = ACNewPasswordVM(service: service)
        let viewController = ACNewPasswordVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToDoneScreen() -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = ACDoneVM(service: service)
        let viewController = ACDoneVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToContactScreen() -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = ACContactVM(service: service)
        let viewController = ACContactVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
}



