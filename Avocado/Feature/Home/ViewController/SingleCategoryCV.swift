//
//  SingleCategoryCV.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/13.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

final class SingleCategoryCV: BaseVC {
    
    private var viewModel: SingleCategoryVM
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
    }
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "카테고리 데모"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        
        $0.backgroundColor = .systemCyan
    }
    
    private let legalView = LegalView()
    
    init(viewModel: SingleCategoryVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setViewDidLoad() {
        // 초기 메인데이터 API call]
        viewModel.input.actionViewDidLoad.accept(())
    }
    
    override func setProperty() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(titleLabel)
    }
    
    override func setConstraint() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
import SPIndicator

struct SingleCategoryCVPreview: PreviewProvider {
    static var previews: some View {
        
        let viewModel = SingleCategoryVM(service: MainService())
        return UINavigationController(rootViewController: SingleCategoryCV(viewModel: viewModel)).toPreview()
    }
}
#endif

