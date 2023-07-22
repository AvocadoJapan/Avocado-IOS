//
//  OtherEmailVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxRelay
import RxSwift
import Then
import RxKeyboard

final class OtherEmailVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "다른 이메일로 인증하기"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    private lazy var otherEmailInput = InputView(label: "이메일",
                                                 placeholder: "example@example.com",
                                                 colorSetting: .normal,
                                                 regSetting: .email,
                                                 keyboardType: .emailAddress)
    
    private lazy var confirmButton = BottomButton(text: "인증번호 요청")
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "현재 입력된 이메일"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private lazy var prevEmailLabel = UILabel().then {
        $0.text = "sample@avocadojp.com"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private lazy var accountCenterButton: SubButton = SubButton(text: "계정 센터")
    
    let viewModel: EmailCheckVM
    
    init(viewModel: EmailCheckVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setProperty() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setLayout() {
        [titleLabel, descriptionLabel, prevEmailLabel, otherEmailInput, confirmButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        prevEmailLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(30)
        }

        otherEmailInput.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(prevEmailLabel.snp.bottom).offset(30)
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
        RxKeyboard.instance.visibleHeight
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
struct OtherEmailVCPreview: PreviewProvider {
    static var previews: some View {
        return OtherEmailVC(viewModel: EmailCheckVM(service: AuthService(), email: "", password: "")).toPreview()
    }
}
#endif

