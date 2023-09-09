//
//  SearchFlow.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/09.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa

final class SearchFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController = BaseNavigationVC()
    
    init() {
        Logger.d("SearchFlow init")
    }
    
    deinit {
        Logger.d("SearchFlow deinit")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? SearchStep else { return .none }
        
        switch step {
        case .searchIsRequired: return navigateSearch()
        case .searchIsComplete: return .none
        }
    }
    
    private func navigateSearch() -> FlowContributors {
        let service = SearchService()
        let viewModel = SearchVM(service: service)
        let viewController = SearchVC(viewModel: viewModel)
        
        // 스무스 애니메이션 적용
        rootViewController.view.fadeOut()
        rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
}
