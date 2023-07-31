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
        
        guard let step = step as? SplashStep else { return .none }
        
        switch step {
        
        case .splashIsRequired:
            return .none
        case .tokenIsRequired:
            return .none
        case .tokenGetComplete:
            return .none
        case .errorOccurred(let error):
            _ = error
            return .none
        }
    }
    
    // private func
}

