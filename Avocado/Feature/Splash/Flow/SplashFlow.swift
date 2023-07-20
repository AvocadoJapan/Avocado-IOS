//
//  SplashFlow.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/14.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxRelay
import RxCocoa

final class SplashFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
//    private let services: SomeService

    init() {
//        self.services = services
        Logger.d("Splash init")
    }
    
    deinit {
        Logger.d("Splash deinit")
    }

    func navigate(to step: Step) -> FlowContributors {

        guard let step = step as? SplashStep else { return .none }

        switch step {
            
        case .tokenIsRequired:
            return navigateToWelcomeScreen()
        case .tokenGetComplete:
            return navigateToMainScreen()
        case .errorOccurred(let error):
            return navigateToFailScreen(with: error)
        }
    }

    private func navigateToWelcomeScreen() -> FlowContributors {
//        let viewController = WelcomeVC(viewModel: WelcomeVM(service: AuthService()))
//        
//        self.rootViewController.pushViewController(viewController, animated: false)
//        
//        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel))
    }
    
    private func navigateToMainScreen() -> FlowContributors {
        
    }

    private func navigateToFailScreen (with error: NetworkError) -> FlowContributors {
        
    }
}
