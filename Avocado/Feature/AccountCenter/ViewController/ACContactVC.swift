//
//  ACContactVC.swift.swift
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

final class ACContactVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "앗, 문제가 복잡하군요"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25,
                                    weight: .heavy)
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "에러코드 : AVDC-0024"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14,
                                    weight: .semibold)
    }
    
    private lazy var emailLabel = UILabel().then {
        $0.text = "Contact@avocadojp.com"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16,
                                    weight: .bold)
    }
    
    private lazy var guideLabel = UILabel().then {
        $0.text = "위 이메일로 에러코드와 현재상황을 보내주세요. 확인 후 빠른시일내 처리를 도와드리겠습니다."
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14,
                                    weight: .semibold)
    }
    
    private lazy var confirmButton = BottomButton(text: "확인")
    
    private let viewModel: ACContactVM
    
    init(viewModel: ACContactVM) {
        self.viewModel = viewModel
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setProperty() {
        view.backgroundColor = .white
    }
    
    override func setLayout() {
        [titleLabel, descriptionLabel, emailLabel, guideLabel, confirmButton].forEach {
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
        
        emailLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(30)
        }
        
        guideLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emailLabel.snp.bottom).offset(5)
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
struct ACContactVCPreview: PreviewProvider {
    static var previews: some View {
        let service = AccountCenterService()
        let viewModel = ACContactVM(service: service)
        
        return ACContactVC(viewModel: viewModel).toPreview()
    }
}
#endif



