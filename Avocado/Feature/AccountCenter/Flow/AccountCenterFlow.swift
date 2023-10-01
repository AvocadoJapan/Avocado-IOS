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
        case .emailCheckIsRequired(let type, let email): return navigateToEmailCheckScreen(type: type,
                                                                                           email: email)
        case .passwordIsRequired(let type, let email): return navigateToPasswordScreen(type: type,
                                                                                       email: email)
        case .newPasswordIsRequired(let type): return navigateToNewPasswordScreen(type: type)
        case .doneIsRequired(let type): return navigateToDoneScreen(type: type)
        case .contactIsRequired(let type): return navigateToContactScreen(type: type)
            
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
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
    
    private func navigateToEmailScreen(type: AccountCenterDataType) -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = ACEmailVM(service: service,
                                  type: type)
        let viewController = ACEmailVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
    
    private func navigateToEmailCheckScreen(type: AccountCenterDataType, email: String) -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = ACEmailCheckVM(service: service,
                                       type: type,
                                       email: email)
        let viewController = ACEmailCheckVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController,
                                              animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
    
    private func navigateToPasswordScreen(type: AccountCenterDataType, email: String) -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = ACPasswordVM(service: service,
                                     type: type,
                                     email: email)
        let viewController = ACPasswordVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController,
                                              animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
    
    private func navigateToNewPasswordScreen(type: AccountCenterDataType) -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = ACNewPasswordVM(service: service,
                                        type: type)
        let viewController = ACNewPasswordVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController,
                                              animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
    
    private func navigateToDoneScreen(type: AccountCenterDataType) -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = ACDoneVM(service: service, type: type)
        let viewController = ACDoneVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
    
    private func navigateToContactScreen(type: AccountCenterDataType) -> FlowContributors {
        let service = AccountCenterService()
        let viewModel = ACContactVM(service: service, type: type)
        let viewController = ACContactVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
    
}



