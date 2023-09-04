//
//  EmailCheckVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/28.
//

import UIKit
import SnapKit
import RxCocoa
import RxRelay
import RxSwift
import Then
import RxKeyboard

final class EmailCheckVC: BaseVC {
    
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
    
    private lazy var otherEmailButton: SubButton = SubButton(text: "다른 이메일로 인증하기")
    
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
        [titleLabel, emailLabel, descriptionLabel, confirmCodeInput, subButtonStackView, confirmButton].forEach {
            view.addSubview($0)
        }
        
        [reqNewCodeButton, otherEmailButton, accountCenterButton].forEach {
            subButtonStackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
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
        let output = viewModel.transform(input: viewModel.input)
        
        viewModel.input.userEmailRelay
            .bind(to: emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        confirmCodeInput
            .userInput
            .bind(to: viewModel.input.confirmCodeRelay)
            .disposed(by: disposeBag)
        
        // 이메일 재 전송
        output
            .successEmailResendPublish
            .asSignal()
            .emit(onNext: { _ in
//                let alertController = UIAlertController(title: "", message: "인증번호를 다시 보냈습니다!", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "확인", style: .default))
//                
//                self?.present(alertController, animated: true)
                
                SPIndicator.present(title: "성공", message: "인증번호를 다시 보냈습니다", preset: .done, haptic: .success)
            })
            .disposed(by: disposeBag)
        
        // 다른 이메일로 인증
        output
            .successDeleteTepmAccount
            .asSignal()
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.steps.accept(AuthStep.otherEmailIsRequired(oldEmail: self.viewModel.input.userEmailRelay.value))
            })
            .disposed(by: disposeBag)
        
        // 이메일 인증 성공
        output
            .successEmailCheckPublish
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.viewModel.steps.accept(AuthStep.regionIsRequired)
            })
            .disposed(by: disposeBag)
        
        output
            .errEventPublish
            .asSignal()
            .emit(onNext: { err in
//                let alertController = UIAlertController(title: "", message: err.errorDescription, preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "확인", style: .default))
//                
//                self?.present(alertController, animated: true)
                SPIndicator.present(title: "알 수 없는 에러", message: err.errorDescription, preset: .error, haptic: .error)
            })
            .disposed(by: disposeBag)
        
        confirmButton
            .rx
            .tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(onNext: { [weak self] void in
                self?.viewModel.input.actionConfirmSignUpCodeRelay.accept(void)
                /* Mocking
                self?.viewModel.steps.accept(AuthStep.regionIsRequired)
                 */
            })
            .disposed(by: disposeBag)
        
        reqNewCodeButton
            .rx
            .tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(onNext: { [weak self] void in
                self?.viewModel.input.actionResendSignUpCodeRelay.accept(void)
            })
            .disposed(by: disposeBag)
        
        otherEmailButton
            .rx
            .tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(onNext: { [weak self] _ in
                self?.viewModel.input.actionOtherEmailSignUpRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        //키보드 버튼 애니메이션
        RxKeyboard.instance
                .visibleHeight
                .skip(1)
                .drive(onNext: { [weak self] height in
                    guard let self = self else { return }
                    self.confirmButton.keyboardMovement(from:self.view, height: height)
                })
                .disposed(by: disposeBag)
                
        // Notification
        NotificationCenter
                .default
                .rx
                .notification(Notification.Name("reloadEmailCheck"))
                .withUnretained(self)
                .bind { [weak self] (_, notification) in
                    guard let self = self else { return }
                    let newEmail = notification.object as! String
                    self.viewModel.input.userEmailRelay.accept(newEmail)
                }
                .disposed(by: disposeBag)
                
    }

}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
import SPIndicator
struct EmailCheckVCPreview: PreviewProvider {
    static var previews: some View {
        return EmailCheckVC(viewModel: EmailCheckVM(service: AuthService(), email: "", password: "")).toPreview()
    }
}
#endif
