//
//  MainFlow.swift
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
final class MainFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    init(root: UINavigationController) {
        self.rootViewController = root
        Logger.d("MainFlow init")
    }
    
    private var rootViewController = UINavigationController()
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? MainStep else { return .none }
        
        switch step {

        case .errorOccurred(let error):
            
            return navigateToFailScreen(with: error)
        case .mainIsRequired(let user):
            return navigateToMainScreen(user: user)
        case .tokenIsRequired:
            return .none
        case .tokenGetComplete:
            return .none
        }
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
    
    private func navigateToMainScreen(user: User) -> FlowContributors {
        let service = MainService()
        let viewModel = MainVM(service: service, user: user)
        let viewController = MainVC(viewModel: viewModel)
        
        // 스무스 애니메이션 적용
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        rootViewController.view.layer.add(transition, forKey: kCATransition)
        
        rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(flowContributor: .contribute(withNext: viewController))
    }
}

