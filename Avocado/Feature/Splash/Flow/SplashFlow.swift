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

// 플로우는 화면 흐름 이벤트가 들어오면 로직처리 및 의존성 주입
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
        
        case .splashIsRequired:
            return navigateToSplashScreen()
        case .tokenIsRequired:
            return navigateToWelcomeScreen()
        case .tokenGetComplete:
            return navigateToMainScreen()
        case .errorOccurred(let error):
            return navigateToFailScreen(with: error)
        }
    }
    
    private func navigateToSplashScreen() -> FlowContributors {
        let splashVM = SplashVM(service: AuthService())
        let splashVC = SplashVC(viewModel: splashVM)
        rootViewController.setViewControllers([splashVC], animated: false)
        return .one(flowContributor: .contribute(withNext: splashVC))
    }
    
    private func navigateToWelcomeScreen() -> FlowContributors {
        let welcomeVM = WelcomeVM(service: AuthService())
        let welcomeVC = WelcomeVC(viewModel: welcomeVM)
        rootViewController.setViewControllers([welcomeVC], animated: false)
        return .one(flowContributor: .contribute(withNext: welcomeVC))
    }
    
    private func navigateToMainScreen() -> FlowContributors {
        let mainVM = MainVM()
        let mainVC = MainVC(vm: mainVM)
        rootViewController.setViewControllers([mainVC], animated: false)
        return .one(flowContributor: .contribute(withNext: mainVC))
    }

    private func navigateToFailScreen (with error: NetworkError) -> FlowContributors {
        let failVC = FailVC(error: error)
        rootViewController.setViewControllers([failVC], animated: false)
        return .one(flowContributor: .contribute(withNext: failVC))
    }
}
