//
//  ACEmailCheckVC.swift
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
import RxKeyboard

final class ACEmailCheckVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "앗, 잠시만요"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    private lazy var confirmCodeInput = InputView(label: "인증번호",
                                                  colorSetting: .normal,
                                                  keyboardType: .numberPad)
    
    private lazy var confirmButton = BottomButton(text: "인증하기")
    
    private lazy var emailLabel = UILabel().then {
        $0.text = "sample@avocadojp.com"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "30분 이내 이메일을 인증해주세요"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private lazy var subButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15
        $0.alignment = .trailing
    }
    
    private lazy var reqNewCodeButton: SubButton = SubButton(text: "인증번호 다시 보내기")
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setProperty() {
        view.backgroundColor = .white
    }
    
    override func setLayout() {
        [titleLabel, emailLabel, descriptionLabel, confirmCodeInput, subButtonStackView, confirmButton].forEach {
            view.addSubview($0)
        }
        
        [reqNewCodeButton].forEach {
            subButtonStackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        emailLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emailLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(30)
        }

        confirmCodeInput.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
        }

        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        subButtonStackView.snp.makeConstraints {
            $0.top.equalTo(confirmCodeInput.snp.bottom).offset(10)
            $0.right.equalToSuperview().inset(15)
        }
    }
    
    
    override func bindUI() {
        //키보드 버튼 애니메이션
        RxKeyboard.instance
                .visibleHeight
                .skip(1)
                .drive(onNext: { [weak self] height in
                    guard let self = self else { return }
                    self.confirmButton.keyboardMovement(from:self.view, height: height)
                })
                .disposed(by: disposeBag)
    }
}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
import SPIndicator
struct ACEmailCheckVCPreview: PreviewProvider {
    static var previews: some View {
        return ACEmailCheckVC().toPreview()
    }
}
#endif

