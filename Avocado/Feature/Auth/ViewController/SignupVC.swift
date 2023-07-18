//
//  SignupVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxRelay
import RxSwift
import Then
import RxKeyboard

final class SignupVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "회원가입"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    private lazy var inputField = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private lazy var emailInput = InputView(label: "이메일",
                                            placeholder: "example@example.com",
                                            colorSetting: .normal,
                                            regSetting: .email,
                                            keyboardType: .emailAddress)
    
    private lazy var passwordInput = InputView(label: "비밀번호",
                                               placeholder: "********",
                                               colorSetting: .normal,
                                               regSetting: .password,
                                               passwordable: true)
    
    private lazy var passwordCheckInput = InputView(label: "비밀번호 확인",
                                                    placeholder: "********",
                                                    colorSetting: .normal,
                                                    passwordable: true)
    
    private lazy var confirmButton = BottomButton(text: "회원가입")
    
    private let scrollView = UIScrollView()
    
    private let containerView = UIView()
    
    private var viewModel: SignUpVM
    
    init(viewModel: SignUpVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setProperty() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    override func setLayout() {
        
        [scrollView, confirmButton].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(containerView)
        
        [titleLabel, inputField].forEach {
            containerView.addSubview($0)
        }
        
        [emailInput, passwordInput, passwordCheckInput].forEach {
            inputField.addArrangedSubview($0)
        }
        
        
    }
    
    override func setConstraint() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        inputField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    override func bindUI() {
        
        //MARK: - INPUT BINDING
        emailInput
            .userInput
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.emailBehavior.accept(text)
            })
            .disposed(by: disposeBag)
        
        passwordInput
            .userInput
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.passwordBehavior.accept(text)
                
            })
            .disposed(by: disposeBag)
        
        passwordCheckInput
            .userInput
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.viewModel.passwordCheckBehavior.accept(text)
                
                self.passwordCheckInput
                    .rightLabelString
                    .accept(self.viewModel.validatePasswordMatch())
            })
            .disposed(by: disposeBag)
        
        //MARK: - OUTPUT BINDING
        viewModel
            .isValidObservable
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel
            .isValidObservable
            .map { $0 ? .black : .lightGray}
            .bind(to: confirmButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel
            .errEventPublish
            .asSignal()
            .emit(onNext: { [weak self] message in
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .successEventPublish
            .asSignal()
            .emit(onNext: { [weak self] isSuccess in
                guard let self = self else { return }
                
                if isSuccess {
                    let authService = AuthService()
                    let emailCheckVM = EmailCheckVM(service: authService,
                                                    email: viewModel.emailBehavior.value,
                                                    password: viewModel.passwordBehavior.value)
                    let emailCheckVC = EmailCheckVC(viewModel: emailCheckVM)
                    let emailCheckNavigationVC = emailCheckVC.makeBaseNavigationController()
                    self.present(emailCheckNavigationVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        confirmButton
            .rx
            .tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .do(onNext: { [weak self] in
                self?.emailInput.keyboardHidden()
                self?.passwordInput.keyboardHidden()
                self?.passwordCheckInput.keyboardHidden()
            })
            .drive(onNext: { [weak self] _ in
                self?.viewModel.signUp()
                /*
                 Mocking
                 
                 guard let self = self else { return }
                 let authService = AuthService()
                 let emailCheckVM = EmailCheckVM(service: authService,
                                                 email: viewModel.emailObserver.value,
                                                 password: viewModel.passwordObserver.value)
                 let emailCheckVC = EmailCheckVC(vm: emailCheckVM).makeBaseNavigationController()
                 self.navigationController?.showDetailViewController(emailCheckVC, sender: nil)
                 */
            })
            .disposed(by: disposeBag)
                
        RxKeyboard.instance.visibleHeight
            .do(onNext: { [weak self] height in
                self?.navigationController?.setNavigationBarHidden(height > 0, animated: true)
            })
            .skip(1)
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                self.confirmButton.keyboardMovement(from:self.view, height: height)
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // 커스텀 메소드
    @objc func didTapScrollView() {
        self.view.endEditing(true)
    }
}


// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct SignupVCPreview: PreviewProvider {
    static var previews: some View {
        return SignupVC(viewModel: SignUpVM(service: AuthService())).toPreview()
    }
}
#endif
