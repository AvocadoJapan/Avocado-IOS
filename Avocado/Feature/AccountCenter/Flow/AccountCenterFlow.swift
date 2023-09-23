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
        
        case .findEmailIsRequired: return .none
        case .findPasswordIsRequired: return .none
        case .accountLockedIsRequired: return .none
        case .confirmCodeUnvalidIsRequired: return .none
        case .code2FAUnvalidIsRequired: return .none
        case .contactCustomerCenterIsRequired: return .none
        case .accountHackedIsRequired: return .none
        case .accountDeleteIsRequired: return .none
        
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
    
}



