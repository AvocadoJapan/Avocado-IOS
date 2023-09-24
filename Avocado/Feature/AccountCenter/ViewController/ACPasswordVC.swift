//
//  ACPasswordVC.swift
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

final class ACPasswordVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    private lazy var passwordInput = InputView(label: "비밀번호",
                                               placeholder: "**********",
                                               colorSetting: .normal,
                                               regSetting: .password,
                                               passwordable: true)
    
    private lazy var confirmButton = BottomButton(text: "인증하기")
    
    private lazy var emailLabel = UILabel().then {
        $0.text = "sample@avocadojp.com"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "요청을 수행하기 위해서는 비밀번호 확인이 필요해요"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
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
        [titleLabel, emailLabel, descriptionLabel, passwordInput, confirmButton].forEach {
            view.addSubview($0)
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

        passwordInput.snp.makeConstraints {
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
struct ACPasswordVCPreview: PreviewProvider {
    static var previews: some View {
        return ACPasswordVC().toPreview()
    }
}
#endif




