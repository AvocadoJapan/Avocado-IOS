//
//  EmailCheckVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/28.
//

import Foundation

import UIKit
import SnapKit
import RxCocoa
import RxRelay
import RxSwift
import Then

class EmailCheckVC: BaseVC {
    
    fileprivate lazy var titleLabel = UILabel().then {
        $0.text = "앗, 잠시만요"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    fileprivate lazy var label = UILabel().then {
        $0.text = ""
        $0.numberOfLines = 0
        $0.textAlignment = .right
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private lazy var confirmCodeInput : InputView = InputView(label: "인증번호", colorSetting: .normal)
    
    private lazy var confirmButton : BottomButton = BottomButton(text: "인증하기")
    
    fileprivate lazy var emailLabel = UILabel().then {
        $0.text = "sample@avocadojp.com"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    fileprivate lazy var descriptionLabel = UILabel().then {
        $0.text = "30분 이내 이메일을 인증해주세요"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    fileprivate lazy var optionLabel = UILabel().then {
        $0.text = "다른 이메일로 인증하기  >"
        $0.numberOfLines = 0
        $0.textAlignment = .right
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    fileprivate lazy var accountLabel = UILabel().then {
        $0.text = "계정 센터  >"
        $0.numberOfLines = 0
        $0.textAlignment = .right
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    
    var disposeBag = DisposeBag()
    
    override func setProperty() {
        view.backgroundColor = .white
    }
    
    override func setLayout() {
        [titleLabel,emailLabel, descriptionLabel, confirmCodeInput, optionLabel, accountLabel, confirmButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview().offset(30)
        }
        
        emailLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().offset(30)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emailLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().offset(30)
        }

        confirmCodeInput.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(20)
        }
        
        optionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(confirmCodeInput.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(30)
        }
        
        accountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(optionLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(30)
        }

        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(20)
        }

    }

}

//extension MainVC : UAInputViewDelegate {
//    func onUserInputChange(input: String) {
//        print(#fileID, #function, #line, "- UAInputViewDelegate input : \(input)")
//    }
//}


// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct EmailCheckVCPreview: PreviewProvider {
    static var previews: some View {
        return EmailCheckVC().toPreview()
    }
}
#endif
