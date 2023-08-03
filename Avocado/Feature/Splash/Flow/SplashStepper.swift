//
//  SplashStepper.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/21.
//

import Foundation
import RxFlow
import RxRelay
import RxSwift

// 리모콘
final class SplashStepper: Stepper {
    let steps: PublishRelay<Step> = PublishRelay()
    private let disposeBag = DisposeBag()
    
    func readyToEmitSteps() {
        print(#fileID, #function, #line, "- ")
    }
}
