//
//  SettingFlow.swift
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
final class SettingFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    init(root: BaseNavigationVC) {
        self.rootViewController = root
        Logger.d("Setting init")
    }
    
    private var rootViewController = BaseNavigationVC()
    
    func navigate(to step: Step) -> FlowContributors {
        
        guard let step = step as? SettingStep else { return .none }
        
        switch step {
        
        case .settingIsComplete:
            return .end(forwardToParentFlowWithStep: AppStep.mainIsRequired)
        case .errorOccurred(let error):
            return .end(forwardToParentFlowWithStep: AppStep.errorOccurred(error: error))
        }
    }
}

