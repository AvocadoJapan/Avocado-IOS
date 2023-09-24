//
//  ACEmailVC.swift
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

final class ACEmailVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "이메일 확인"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25,
                                    weight: .heavy)
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "요청을 수행하기 위해서는 이메일 확인이 필요해요"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14,
                                    weight: .semibold)
    }
    
    private lazy var emailInput = InputView(label: "이메일",
                                            placeholder: "example@example.com",
                                            colorSetting: .normal,
                                            regSetting: .email,
                                            keyboardType: .emailAddress)
    
    private lazy var confirmButton = BottomButton(text: "확인")
    
    init() {
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
        [titleLabel, descriptionLabel, emailInput, confirmButton].forEach {
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
        
        emailInput.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
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
struct ACEmailVCPreview: PreviewProvider {
    static var previews: some View {
        return ACEmailVC().toPreview()
    }
}
#endif

