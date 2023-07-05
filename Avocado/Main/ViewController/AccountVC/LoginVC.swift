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

class LoginVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "로그인"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    private lazy var inputField = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private lazy var emailInput = InputView(label: "이메일", placeholder: "example@example.com", colorSetting: .normal, regSetting: .email)
    
    private lazy var passwordInput = InputView(label: "비밀번호", placeholder: "**********", colorSetting: .normal, regSetting: .password, passwordable: true)
    
    private lazy var confirmButton = BottomButton(text: "로그인")
    
    private lazy var accountCenterButton = SubButton(text: "계정 센터")
        
    
    var disposeBag = DisposeBag()
    var viewModel: LoginVM
    
    init(vm viewModel: LoginVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setProperty() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func setLayout() {
        [titleLabel, inputField, accountCenterButton, confirmButton].forEach {
            view.addSubview($0)
        }
        
        [emailInput, passwordInput].forEach {
            inputField.addArrangedSubview($0)
        }
        
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }

        inputField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        
        accountCenterButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(inputField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(30)
        }

        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.left.equalToSuperview().inset(20)
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
            .map { $0 ? .black : .lightGray}
            .bind(to: confirmButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel
            .isVaild
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        confirmButton
            .rx
            .tap
            .subscribe { [weak self] _ in
                self?.viewModel.login()
            }
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
            .emit(onNext: { [weak self] _ in
                let mainVM = MainVM()
                let mainVC = MainVC(vm: mainVM)
                let navigationController = mainVC.getBaseNavigationController()
                
                navigationController.modalPresentationStyle = .fullScreen
                self?.present(navigationController, animated: false)
            })
            .disposed(by: disposeBag)
        
        // accountCenter 옵션
        // FIXME: 계정 센터 VC를 만들면 나중에 거기로 연결해야함
        accountCenterButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        
        //키보드 버튼 애니메이션
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: {
                self.confirmButton.keyboardMovement(from:self.view, height: $0)
            })
            .disposed(by: disposeBag)
        
//        RxKeyboard.instance.visibleHeight
//            .drive(onNext: { [weak self] keyboardVisibleHeight in
//                self?.view.frame.origin.y = -keyboardVisibleHeight/3
//            })
//            .disposed(by: disposeBag)
            
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
}


// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct LoginVCPreview: PreviewProvider {
    static var previews: some View {
        return LoginVC(vm: LoginVM(service: AuthService())).toPreview()
    }
}
#endif

