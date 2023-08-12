//
//  MainVC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import Then
import SnapKit
import RxDataSources
import RxRelay
import RxSwift
/**
 *##화면 명: Avocado 메인화면 (배너, 카테고리 별 상품 정보를 확인가능)
 */
final class MainVC: BaseVC {
    
    private var viewModel: MainVM
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let productGroupView = ProductGroupView()
    private let productGroupView2 = ProductGroupView()
    private let productGroupView3 = ProductGroupView()
    private let productGroupView4 = ProductGroupView()
    private let productGroupView5 = ProductGroupView()
    
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
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        [productGroupView, productGroupView2, productGroupView3, productGroupView4, productGroupView5].forEach {
            stackView.addArrangedSubview($0)
        }
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func setLayout() {
        
    }
    override func setConstraint() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        [productGroupView, productGroupView2, productGroupView3, productGroupView4, productGroupView5].forEach {
            $0.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(540)
            }
        }
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
