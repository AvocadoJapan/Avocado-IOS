//
//  SplashStepper.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/20.
//

import Foundation

class AppStepper: Stepper {
    let steps: PublishRelay<Step> = PublishRelay()
    private let disposeBag = DisposeBag()
    
    var initialStep: Step {
        return AppStep.splashIsRequired
    }
    
    func readyToEmitSteps() {
        print(#fileID, #function, #line, "- ")
        
    }
}
