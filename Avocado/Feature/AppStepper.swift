//
//  AppStepper.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/30.
//

import Foundation
import RxSwift
import RxRelay
import RxFlow

final class AppStepper: Stepper {
    let steps: PublishRelay<Step> = PublishRelay()
    private let disposeBag = DisposeBag()
    
    // init될때 처음으로 타는 스탭 Stepper 참고
    var initialStep: Step {
        return AppStep.appIsStarted
    }
    
    func readyToEmitSteps() {
        print(#fileID, #function, #line, "- ")
        
    }
}
