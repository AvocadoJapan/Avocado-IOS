//
//  AuthStepper.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/23.
//

import Foundation
import RxFlow
import RxRelay
import RxSwift

final class AuthStepper: Stepper {
    let steps: PublishRelay<Step> = PublishRelay()
    private let disposeBag = DisposeBag()
    
    // init될때 처음으로 타는 스탭 Stepper 참고
    var initialStep: Step {
        return AuthStep.welcomeIsRequired
    }
    
    func readyToEmitSteps() {
        print(#fileID, #function, #line, "- ")
        
    }
}
