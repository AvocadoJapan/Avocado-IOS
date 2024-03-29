//
//  LoginVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxRelay
import RxSwift
import Then
import RxKeyboard

final class LoginVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "로그인"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    private lazy var inputFieldStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private lazy var emailInput = InputView(label: "이메일",
                                            placeholder: "example@example.com",
                                            colorSetting: .normal,
                                            regSetting: .email,
                                            keyboardType: .emailAddress)
    
    private lazy var passwordInput = InputView(label: "비밀번호",
                                               placeholder: "**********",
                                               colorSetting: .normal,
                                               regSetting: .password,
                                               passwordable: true)
    
    private lazy var confirmButton = BottomButton(text: "로그인")
    
    private lazy var accountCenterButton = SubButton(text: "계정 센터")
    
    private let scrollView = UIScrollView()
    
    private let containerView = UIView()
    
    var viewModel: LoginVM
    
    init(viewModel: LoginVM) {
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
        
        [titleLabel, inputFieldStackView, accountCenterButton].forEach {
            containerView.addSubview($0)
        }
        
        [emailInput, passwordInput].forEach {
            inputFieldStackView.addArrangedSubview($0)
        }
        
    }
    
    override func setConstraint() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
        }

        inputFieldStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        accountCenterButton.snp.makeConstraints {
            $0.top.equalTo(inputFieldStackView.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().inset(40)
        }

        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }

    }
    
    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        
        emailInput
            .userInput
            .bind(to: viewModel.input.emailBehavior)
            .disposed(by: disposeBag)
        
        passwordInput
            .userInput
            .bind(to: viewModel.input.passwordBehavior)
            .disposed(by: disposeBag)
        
        emailInput
            .isVaild
            .bind(to: viewModel.input.emailVaildBehavior)
            .disposed(by: disposeBag)
        
        passwordInput
            .isVaild
            .bind(to: viewModel.input.passwordVaildBehavior)
            .disposed(by: disposeBag)
        
        confirmButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] void in
                self?.viewModel.input.actionLoginPublish.accept(void)
            })
            .disposed(by: disposeBag)
        
        accountCenterButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.viewModel.steps.accept(AuthStep.accountCenterIsRequired)
            })
            .disposed(by: disposeBag)
        
        
        output.successEventPublish
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.viewModel.steps.accept(AuthStep.loginIsComplete)
            })
            .disposed(by: disposeBag)
        
        output.errEventPublish
            .asSignal()
            .emit { [weak self] err in
                let alert = UIAlertController(title: "", message: err.errorDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                
                self?.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
        
        output
            .confirmEnabledPublish
            .map { $0 ? .black : .lightGray }
            .bind(to: confirmButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output
            .confirmEnabledPublish
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //키보드 버튼 애니메이션
        RxKeyboard.instance.visibleHeight
            .do(onNext: { [weak self] height in
                self?.navigationController?.setNavigationBarHidden(height > 0, animated: true)
            })
            .skip(1)
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                self.confirmButton.keyboardMovement(from: self.view, height: height)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
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
struct LoginVCPreview: PreviewProvider {
    static var previews: some View {
        return LoginVC(viewModel: LoginVM(service: AuthService())).toPreview()
    }
}
#endif
