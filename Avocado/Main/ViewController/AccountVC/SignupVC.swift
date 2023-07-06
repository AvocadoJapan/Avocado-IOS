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

class SignupVC: BaseVC {
    
    fileprivate lazy var titleLabel = UILabel().then {
        $0.text = "회원가입"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    private lazy var inputField = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private lazy var emailInput = InputView(label: "이메일", placeholder: "example@example.com", colorSetting: .normal, regSetting: .email)
    
    private lazy var passwordInput = InputView(label: "비밀번호", placeholder: "********", colorSetting: .normal,regSetting: .password, passwordable: true)
    
    private lazy var passwordCheckInput = InputView(label: "비밀번호 확인", placeholder: "********", colorSetting: .normal, passwordable: true)
    
        
    fileprivate lazy var toggleView = UIStackView().then {
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    fileprivate lazy var toggleText = UILabel().then {
        $0.text = "서비스 이용약관에 동의"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .darkGray
    }
    
    fileprivate lazy var toggle = UISwitch().then {
        $0.isOn = false
        $0.onTintColor = .black
    }
    
    fileprivate lazy var confirmButton = BottomButton(text: "회원가입")
    
    var disposeBag = DisposeBag()
    var viewModel: SignUpVM
    
    init(vm viewModel: SignUpVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setProperty() {
        view.backgroundColor = .white
    }
    
    override func setLayout() {
        [titleLabel, inputField, toggleView, confirmButton].forEach {
            view.addSubview($0)
        }
        
        [emailInput, passwordInput, passwordCheckInput].forEach {
            inputField.addArrangedSubview($0)
        }
        
        [toggleText, toggle].forEach {
            toggleView.addArrangedSubview($0)
        }
        
        
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }

        inputField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(20)
        }

        toggleView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(inputField.snp.bottom).offset(30)
        }
        
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.left.equalToSuperview().offset(20)
        }
    }
    
    override func bindUI() {
        
        emailInput
            .userInput
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.emailObserver.accept(text)
            })
            .disposed(by: disposeBag)
        
        passwordInput
            .userInput
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.passwordObserver.accept(text)
                
            })
            .disposed(by: disposeBag)
        
        viewModel
            .isVaild
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel
            .isVaild
            .map { $0 ? 1 : 0.3 }
            .bind(to: confirmButton.rx.alpha)
            .disposed(by: disposeBag)
        
        viewModel
            .errEvent
            .asSignal()
            .emit(onNext: { [weak self] message in
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .successEvent
            .asSignal()
            .emit(onNext: { [weak self] isSuccess in
                guard let self = self else { return }
                
                if isSuccess {
                    let authService = AuthService()
                    let emailCheckVM = EmailCheckVM(service: authService,
                                                    email: viewModel.emailObserver.value,
                                                    password: viewModel.passwordObserver.value)
                    let emailCheckVC = EmailCheckVC(vm: emailCheckVM)
                    self.navigationController?.pushViewController(emailCheckVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        confirmButton
            .rx
            .tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] in
                self?.emailInput.resignFirstResponder()
                self?.passwordInput.resignFirstResponder()

            }).subscribe { [weak self] _ in
                self?.viewModel.signUp()
            }
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: {
                self.confirmButton.keyboardMovement(from:self.view, height: $0)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct SignupVCPreview: PreviewProvider {
    static var previews: some View {
        return SignupVC(vm: SignUpVM(service: AuthService())).toPreview()
    }
}
#endif
