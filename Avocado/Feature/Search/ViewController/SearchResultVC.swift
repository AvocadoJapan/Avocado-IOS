//
//  SearchResultVC.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/14.
//

import UIKit

final class SearchResultVC: BaseVC {
    
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct SearchResultVCPreview: PreviewProvider {
    static var previews: some View {
        return SearchResultVC().toPreview()
    }
}
#endif
