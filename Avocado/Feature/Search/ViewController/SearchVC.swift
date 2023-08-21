//
//  SearchVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/03.
//

import UIKit

final class SearchVC: BaseVC {
    
    lazy var searchBarV = SearchBarV()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func setLayout() {
        view.addSubview(searchBarV)
    }
    
    override func setConstraint() {
        searchBarV.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.top.equalToSuperview().offset(5)
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct SearchVCPreview: PreviewProvider {
    static var previews: some View {
        return SearchVC().toPreview()
    }
}
#endif
