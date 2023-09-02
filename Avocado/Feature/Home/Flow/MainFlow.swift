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
    
    init(root: BaseNavigationVC) {
        self.rootViewController = root
        Logger.d("MainFlow init")
    }
    
    private var rootViewController = BaseNavigationVC()
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? MainStep else { return .none }
        
        switch step {

        case .errorOccurred(let error):
            return navigateToFailScreen(with: error)
        case .mainIsRequired:
            return navigateToMainScreen()
        case .tokenIsRequired:
            return .none
        case .tokenGetComplete:
            return .none
        case .singleProductIsRequired(let product):
            return navigateToSingleProductScreen(product: product)
        }
    }
    
    private func navigateToFailScreen(with error: NetworkError) -> FlowContributors {
        
        let viewController = FailVC(error: error)
        
        // 스무스 애니메이션 적용
        rootViewController.view.fadeOut()
        rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(flowContributor: .contribute(withNext: viewController))
    }
    
    private func navigateToMainScreen() -> FlowContributors {
        let service = MainService()
        let viewModel = MainVM(service: service)
        let viewController = MainVC(viewModel: viewModel)
        
        // 스무스 애니메이션 적용
        rootViewController.view.fadeOut()
        rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateToSingleProductScreen(product: Product) -> FlowContributors {
        let service = MainService()
        let viewModel = SingleProductVM(service: service, product: product)
        let viewController = SingleProductVC(viewModel: viewModel)
        
        // 탭바 숨기기
        viewController.hidesBottomBarWhenPushed = true
        
        rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
}

