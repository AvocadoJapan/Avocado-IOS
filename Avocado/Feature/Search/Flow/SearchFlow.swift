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
        case .searchResultIsRequired(let content): return navigateSearchResult(content: content)
        case .productDetail(let product): return navigateProductDetail(product: product)
        }
    }
    
    private func navigateSearch() -> FlowContributors {
        let service = SearchService()
        let viewModel = SearchVM(service: service)
        let viewController = SearchVC(viewModel: viewModel)
        
        // 스무스 애니메이션 적용
        rootViewController.view.fadeOut()
        rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: viewModel
            )
        )
    }
    
    private func navigateSearchResult(content: String) -> FlowContributors {
//        let service = SearchService()
        let service = SearchService(isStub: true, sampleStatusCode: 200)
        let viewModel = SearchResultVM(service: service, keyword: content)
        let viewController = SearchResultVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: viewModel
            )
        )
    }
    
    private func navigateProductDetail(product: Product) -> FlowContributors {
        let service = MainService()
        let viewModel = SingleProductVM(service: service, product: product)
        let viewController = SingleProductVC(viewModel: viewModel)
        rootViewController.pushViewController(viewController, animated: true)
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: viewModel
            )
        )
    }
}
