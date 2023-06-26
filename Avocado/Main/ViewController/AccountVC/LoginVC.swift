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

class LoginVC: BaseVC {
    
    fileprivate lazy var titleLabel = UILabel().then {
        $0.text = "로그인"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    private lazy var inputField = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private lazy var emailInput : InputView = InputView(label: "이메일", placeholder: "example@example.com", colorSetting: .normal)
    
    private lazy var passwordInput : InputView = InputView(label: "비밀번호", placeholder: "**********", colorSetting: .normal)
    
    fileprivate lazy var confirmButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        $0.layer.cornerRadius = 20
    }
    
    fileprivate lazy var optionLabel = UILabel().then {
        $0.text = "다른 로그인 옵션 선택  >"
        $0.numberOfLines = 0
        $0.textAlignment = .right
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
        
    
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
    }
    
    override func setLayout() {
        [titleLabel, inputField, optionLabel, confirmButton].forEach {
            view.addSubview($0)
        }
        
        [emailInput, passwordInput].forEach {
            inputField.addArrangedSubview($0)
        }
        
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview().offset(30)
        }

        inputField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(20)
        }
        
        optionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(inputField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(30)
        }

        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(50)
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
            .map { $0 ? 1 : 0.3}
            .bind(to: confirmButton.rx.alpha)
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
            .asDriver()
            .drive(onNext: { [weak self] message in
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .successEvent
            .asDriver()
            .drive(onNext: { [weak self] _ in
                let mainVM = MainVM()
                let mainVC = MainVC(vm: mainVM)
                let navigationController = UINavigationController(rootViewController: mainVC)
                self?.modalPresentationStyle = .fullScreen
                self?.modalTransitionStyle = .coverVertical
                self?.present(navigationController, animated: false)
            })
            .disposed(by: disposeBag)
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        emailInput.setUserInputAction(target: self, action: #selector(handleUserInputFromMainVC(_:)))
        
//        emailInput.userInput
//                    .subscribe(onNext: { input in
//                        print(#fileID, #function, #line, "- input : \(input)")
//                    })
//                    .disposed(by: disposeBag)
    }
    
    @objc func handleUserInputFromMainVC(_ sender: UITextField){
        print(#fileID, #function, #line, "- sender: \(sender.text ?? "")")
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
struct LoginVCPreview: PreviewProvider {
    static var previews: some View {
        return LoginVC(vm: LoginVM(service: AuthService())).toPreview()
    }
}
#endif

