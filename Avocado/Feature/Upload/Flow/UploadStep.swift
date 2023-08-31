//
//  UploadStep.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/30.
//

import RxFlow
import Foundation
import RxRelay
import RxSwift

@frozen enum UploadStep: Step {
    
    case uploadIsRequired
    case uploadIsComplete
}
