//
//  UploadVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/30.
//

import Foundation

final class UploadVC: BaseVC {
    
    private let viewModel: UploadVM
    
    init(viewModel: UploadVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct UploadVCPreview: PreviewProvider {
    static var previews: some View {
        return UploadVC(viewModel: UploadVM(service: UploadService())).toPreview()
    }
}
#endif
