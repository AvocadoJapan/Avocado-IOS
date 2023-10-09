//
//  ProfileStep.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/31.
//

import Foundation
import RxFlow

@frozen enum ProfileStep: Step {
    
    case profileIsRequired
    case profileIsComplete
    case profileDetailIsRequired
    case productDetailIsRequired(product: Product)
    case commentListIsRequired
}
