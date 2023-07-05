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
import RxKeyboard

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
    
    private lazy var confirmCodeInput = InputView(label: "인증번호", colorSetting: .normal)
    
    private lazy var confirmButton = BottomButton(text: "인증하기")
    
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
    
    private lazy var otherEmailButton : SubButton = SubButton(text: "다른 이메일로 인증하기")
    
    private lazy var accountCenterButton : SubButton = SubButton(text: "계정 센터")
    
    var disposeBag = DisposeBag()
    let viewModel: EmailCheckVM
    
    init(vm: EmailCheckVM) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setProperty() {
        view.backgroundColor = .white
    }
    
    override func setLayout() {
        [titleLabel,emailLabel, descriptionLabel, confirmCodeInput, otherEmailButton, accountCenterButton, confirmButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        emailLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emailLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }

        confirmCodeInput.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(20)
        }
        
        otherEmailButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(confirmCodeInput.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(30)
        }
        
        accountCenterButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(otherEmailButton.snp.bottom)
            $0.left.equalToSuperview().offset(30)
        }

        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(20)
        }

    }
    
    override func bindUI() {
        viewModel.userEmail
            .bind(to: emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        confirmCodeInput
            .userInput
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.confirmCode.accept(text)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .successEvent
            .asSignal()
            .emit(onNext: { [weak self] isSuccess in
                let authService = AuthService()
                let profileSettingVM = ProfileSettingVM(service: authService)
                let profileSettingVC = ProfileSettingVC(vm: profileSettingVM)
                let navigaitonVC = profileSettingVC.getBaseNavigationController()
                self?.present(navigaitonVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        confirmButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.viewModel.confirmSignUpCode()
            })
            .disposed(by: disposeBag)
        
        //키보드 버튼 애니메이션
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: {
                self.confirmButton.keyboardMovement(from:self.view, height: $0)
            })
            .disposed(by: disposeBag)
    
            
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
        return EmailCheckVC(vm: EmailCheckVM(service: AuthService(), email: "", password: "")).toPreview()
    }
}
#endif
