//
//  UploadFlow.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/30.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxRelay
import RxCocoa
import Then

// 플로우는 화면 흐름 이벤트가 들어오면 로직처리 및 의존성 주입
final class UploadFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController = BaseNavigationVC()
    
    init(root: BaseNavigationVC) {
        self.rootViewController = root
        Logger.d("UploadFlow init")
    }
    
    deinit {
        Logger.d("UploadFlow deinit")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? UploadStep else { return .none }
        
        switch step {
        case .uploadIsRequired:
            return presentToUploadScreen()
        case .uploadIsComplete:
            return .none
        default :
            return .none
        }
    }
    
    private func presentToUploadScreen() -> FlowContributors {
        
        let service = UploadService()
        let viewModel = UploadVM(service: service)
        let viewController = UploadVC(viewModel: viewModel)

        // 스무스 애니메이션 적용
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        rootViewController.view.layer.add(transition, forKey: kCATransition)
        
//        rootViewController.present(viewController, animated: true)
        rootViewController.setViewControllers([viewController], animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
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
}
