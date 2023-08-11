//
//  MainVC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import RxDataSources
import RxRelay
import RxSwift
/**
 *##화면 명: Avocado 메인화면 (배너, 카테고리 별 상품 정보를 확인가능)
 */
final class MainVC: BaseVC {
    
    private var viewModel: MainVM
    
    init(viewModel: MainVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bindUI() {
        
    }
    
    override func setProperty() {
        
    }
    
    override func setLayout() {
        
    }
    override func setConstraint() {
        
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct MainVCPreview: PreviewProvider {
    static var previews: some View {
        return UINavigationController(
            rootViewController: MainVC(
                viewModel: MainVM(
                    service: MainService(),
                    user: User(
                        userId: "demo",
                        nickName: "demo",
                        updateAt: 1234567,
                        createdAt: 1234567,
                        accounts: Accounts(cognito: "demo"),
                        avatar: Avatar(
                            id: "1234",
                            changedAt: 1234567
                        )
                    )
                )
            )
        ).toPreview()
    }
}
#endif
