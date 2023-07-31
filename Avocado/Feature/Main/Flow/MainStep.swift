//
//  MainStep.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/31.
//

import RxFlow
import Foundation
import RxRelay
import RxSwift


@frozen enum MainStep: Step {
    
    // Loding
    case mainIsRequired
    case tokenIsRequired
    case tokenGetComplete
    case errorOccurred(error: NetworkError)
}
