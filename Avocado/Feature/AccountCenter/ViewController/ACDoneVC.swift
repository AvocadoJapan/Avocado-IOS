//
//  ACDoneVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxRelay
import RxSwift
import Then
import Localize_Swift
import RxDataSources

final class ACDoneVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "완료!"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25,
                                    weight: .heavy)
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "요청한 작업을 정상적으로 처리했어요. 다시 로그인을 시도해보세요."
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14,
                                    weight: .semibold)
    }
    
    private lazy var confirmButton = BottomButton(text: "확인")
    
    private let viewModel: ACDoneVM
    
    init(viewModel: ACDoneVM) {
        self.viewModel = viewModel
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setProperty() {
        view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setLayout() {
        [titleLabel, descriptionLabel, confirmButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraint() {
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
            $0.left.equalToSuperview().offset(30)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(30)
        }

        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
import SPIndicator
struct ACDoneVCPreview: PreviewProvider {
    static var previews: some View {
        let service = AccountCenterService()
        let viewModel = ACDoneVM(service: service, type: .accountHacked)
        
        return ACDoneVC(viewModel: viewModel).toPreview()
    }
}
#endif


