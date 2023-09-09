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
    
    private var viewModel: OtherEmailVM
    
    init(viewModel: OtherEmailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setProperty() {
        view.backgroundColor = .white
        
        // 닫기버튼 추가
        let closeButton = UIBarButtonItem(systemItem: .close, primaryAction: UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        
        navigationItem.leftBarButtonItem = closeButton
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
        let output = viewModel.transform(input: viewModel.input)
        
        viewModel
            .input
            .userOldEmailBehavior
            .bind(to: prevEmailLabel.rx.text)
            .disposed(by: disposeBag)
        
        otherEmailInput
            .userInput
            .bind(to: viewModel.input.userNewEmailBehavior)
            .disposed(by: disposeBag)
        
        confirmButton.rx
            .tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(onNext: { [weak self] void in
                self?.viewModel.input.actionOtherEmailCodePublish.accept(void)
            })
            .disposed(by: disposeBag)
        
        otherEmailInput
            .isVaild
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        otherEmailInput
            .isVaild
            .map {$0 ? .black : .lightGray}
            .bind(to: confirmButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.successOtherEmailCodePublish
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: {
                    // 인증번호 전송이 되었을 경우 notification 발송
                    NotificationCenter.default.post(
                        name: NSNotification.Name("reloadEmailCheck"),
                        object:self?.viewModel.input.userNewEmailBehavior.value)
                })

            })
            .disposed(by: disposeBag)
        
        output.errorEventPublish
            .asSignal()
            .emit(onNext: { err in
//                let alertController = UIAlertController(title: "", message: error.errorDescription, preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "확인", style: .default))
//                
//                self?.present(alertController, animated: true)
                SPIndicator.present(title: "알 수 없는 에러", message: err.errorDescription, preset: .error, haptic: .error)
                
            })
            .disposed(by: disposeBag)
        
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
import SPIndicator
struct OtherEmailVCPreview: PreviewProvider {
    static var previews: some View {
        return OtherEmailVC(viewModel: OtherEmailVM(service: AuthService(), oldEmail: "sample@avocadojp.com")).toPreview()
    }
}
#endif

