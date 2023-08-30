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
            return .none
        case .uploadIsComplete:
            return .none
        default :
            return .none
        }
    }
}
