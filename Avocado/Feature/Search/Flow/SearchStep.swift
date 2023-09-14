//
//  SearchStep.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/09.
//

import Foundation
import RxFlow

@frozen enum SearchStep: Step {
    case searchIsRequired
    case searchIsComplete
    case searchResultIsRequired(content: String)
}
