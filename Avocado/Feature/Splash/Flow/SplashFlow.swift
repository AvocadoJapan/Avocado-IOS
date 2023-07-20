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
        let viewModel = WelcomeVM(service: AuthService())
        let welcomeVC = WelcomeVC(viewModel: viewModel)
        rootViewController.setViewControllers([welcomeVC], animated: false)
        return .one(flowContributor: .contribute(withNext: welcomeVC))
    }
    
    private func navigateToMainScreen() -> FlowContributors {
        let viewModel = WelcomeVM(service: AuthService())
        let welcomeVC = WelcomeVC(viewModel: viewModel)
        rootViewController.setViewControllers([welcomeVC], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: welcomeVC, withNextStepper: viewModel as! Stepper))
    }

    private func navigateToFailScreen (with error: NetworkError) -> FlowContributors {
//        let viewModel = Fail(service: AuthService())
        let failVC = FailVC()
        rootViewController.setViewControllers([failVC], animated: false)
        return .one(flowContributor: .contribute(withNext: failVC))
    }
}
