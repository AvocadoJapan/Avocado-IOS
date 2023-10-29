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
    
    init() {
        Logger.d("ProfileFlow init")
    }
    
    deinit {
        Logger.d("ProfileFlow deinit")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? ProfileStep else { return .none }
        
        switch step {
        case .profileIsRequired: return navigateProfile()
        case .profileIsComplete: return .end(forwardToParentFlowWithStep: AppStep.authIsRequired)
        case .profileDetailIsRequired: return navigateProfileDetail()
        case .productDetailIsRequired(let product): return navigateProductDetail(product: product)
        case .commentListIsRequired: return navigateCommentList()
        }
    }
    
    private func navigateProductDetail(product: Product) -> FlowContributors {
        Logger.d(rootViewController)
        let service = MainService(isStub: true, sampleStatusCode: 200) //Mocking
//        let service = MainService()
        let viewModel = SingleProductVM(service: service, product: product)
        let viewController = SingleProductVC(viewModel: viewModel)
        
        // 후기 리스트화면에서 띄우는 경우
        if let navigationController = rootViewController.presentedViewController as? BaseNavigationVC {
            navigationController.pushViewController(viewController, animated: true)
        }
        else {
            rootViewController.pushViewController(viewController, animated: true)
        }
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: viewModel
            )
        )
    }
    
    private func navigateProfile() -> FlowContributors {
        let service = AuthService()
        let viewModel = ProfileVM(service: service)
        let viewController = ProfileVC(viewModel: viewModel)
        
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
    
    private func navigateProfileDetail() -> FlowContributors {
        let service = ProfileService(isStub: true, sampleStatusCode: 200)
        let viewModel = ProfileDetailVM(service: service)
        let viewController = ProfileDetailVC(viewModel: viewModel)
        
        rootViewController.setNavigationColor()
        rootViewController.pushViewController(viewController, animated: true)
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: viewModel
            )
        )
    }
    
    private func navigateCommentList() -> FlowContributors {
//        let service = ProfileService()
        let service = ProfileService(isStub: true, sampleStatusCode: 200)
        let viewModel = CommentListVM(service: service)
        let viewController = CommentListVC(viewModel: viewModel)
        let navigationController = BaseNavigationVC(rootViewController: viewController)
        navigationController.modalPresentationStyle = .automatic
        rootViewController.present(navigationController, animated: true)
        
        return .one(
            flowContributor: .contribute(
                withNextPresentable: viewController,
                withNextStepper: viewModel
            )
        )
    }
}
