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
    
    // FIXME: 다시보내기 구현
    private lazy var reqNewCodeButton: SubButton = SubButton(text: "인증번호 다시 보내기")
    
    // FIXME: 이 버튼을 누를 경우 인증번호를 보낸 계정이 미인증 계정일때 그 미인증계정을 삭제해야함
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
        [titleLabel, emailLabel, descriptionLabel, reqNewCodeButton, confirmCodeInput, otherEmailButton, accountCenterButton, confirmButton].forEach {
            view.addSubview($0)
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
        
        reqNewCodeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalTo(confirmCodeInput.snp.bottom).offset(20)
        }
        
        otherEmailButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalTo(reqNewCodeButton.snp.bottom)
        }
        
        accountCenterButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalTo(otherEmailButton.snp.bottom)
        }

        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
    }
    
    override func bindUI() {
        viewModel.userEmailRelay
            .bind(to: emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        confirmCodeInput
            .userInput
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.confirmCodeRelay.accept(text)
            })
            .disposed(by: disposeBag)
        
        // 이메일 인증
        viewModel
            .successEmailCheckPublish
            .asSignal()
            .emit(onNext: { [weak self] isSuccess in
                let authService = AuthService()
                let regionVM = RegionSettingVM(service: authService)
                let regionVC = RegionSettingVC(viewModel: regionVM)
                let navigaitonVC = regionVC.makeBaseNavigationController()
                
                self?.present(navigaitonVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 이메일 재 전송
        viewModel
            .successEmailResendPublish
            .asSignal()
            .emit(onNext: { [weak self] _ in
                let alertController = UIAlertController(title: "", message: "인증번호를 다시 보냈습니다!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .default))
                
                self?.present(alertController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .errEventPublish
            .asSignal()
            .emit(onNext: { [weak self] err in
                let alertController = UIAlertController(title: "", message: err.errorDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .default))
                
                self?.present(alertController, animated: true)
            })
            .disposed(by: disposeBag)
        
        confirmButton
            .rx
            .tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(onNext: { [weak self] _ in
                self?.viewModel.confirmSignUpCode()
                /* Mocking
                 let authService = AuthService()
                 let regionVM = RegionSettingVM(service: authService)
                 let regionVC = RegionSettingVC(viewModel: regionVM)
                 let navigaitonVC = regionVC.makeBaseNavigationController()
                 self?.present(navigaitonVC, animated: true)
                 */
            })
            .disposed(by: disposeBag)
        
        reqNewCodeButton
            .rx
            .tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(onNext: { [weak self] _ in
                self?.viewModel.resendSignUpCode()
            })
            .disposed(by: disposeBag)
        
        otherEmailButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.present(OtherEmailVC(), animated: true)
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
struct EmailCheckVCPreview: PreviewProvider {
    static var previews: some View {
        return EmailCheckVC(viewModel: EmailCheckVM(service: AuthService(), email: "", password: "")).toPreview()
    }
}
#endif
