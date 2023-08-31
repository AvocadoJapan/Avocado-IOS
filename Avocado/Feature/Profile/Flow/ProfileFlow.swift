//
//  ProfileFlow.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/31.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa

final class ProfileFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController = BaseNavigationVC()
    
    init(root: BaseNavigationVC) {
        self.rootViewController = root
        Logger.d("ProfileFlow init")
    }
    
    deinit {
        Logger.d("ProfileFlow deinit")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? ProfileStep else { return .none }
        
        switch step {
        case .profileIsRequired: return navigateProfile()
        case .profileIsComplete:
            return .none
        case .productDetailIsRequired(let product): return navigateProductDetail(product: product)
        }
    }
    
    private func navigateProductDetail(product: Product) -> FlowContributors {
        Logger.d(rootViewController)
        let service = MainService(isStub: true, sampleStatusCode: 200) //Mocking
//        let service = MainService()
        let viewModel = SingleProductVM(service: service, product: product)
        let viewController = SingleProductVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
    
    private func navigateProfile() -> FlowContributors {
        let service = ProfileService()
        let viewModel = ProfileVM(service: service)
        let viewController = ProfileVC(viewModel: viewModel)
        
        rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
}
