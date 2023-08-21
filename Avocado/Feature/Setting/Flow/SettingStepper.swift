//
//  SettingStepper.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/31.
//

import Foundation
import RxFlow
import RxRelay
import RxSwift

// 리모콘
final class SettingStepper: Stepper {
    let steps: PublishRelay<Step> = PublishRelay()
    private let disposeBag = DisposeBag()
    
//    // init될때 처음으로 타는 스탭 Stepper 참고
//    var initialStep: Step {
//        return SplashStep.splashIsRequired
//    }
    
    func readyToEmitSteps() {
        print(#fileID, #function, #line, "- ")
        
    }
}

