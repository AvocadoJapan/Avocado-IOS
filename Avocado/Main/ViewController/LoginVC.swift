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
        $0.text = "サインイン"
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
    }
    
    private lazy var inputField = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private lazy var emailInput : InputView = InputView(label: "メールアドレス", placeholder: " example@example.com", colorSetting: .normal)
    
    private lazy var passwordInput : InputView = InputView(label: "パスワード", placeholder: "password", colorSetting: .normal)
        
    fileprivate lazy var toggleView = UIStackView().then {
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    fileprivate lazy var toggleText = UILabel().then {
        $0.text = "次回からログイン省略"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .darkGray
    }
    
    fileprivate lazy var toggle = UISwitch().then {
        $0.isOn = false
        $0.onTintColor = .systemTeal
    }
    
    fileprivate lazy var socialLoginStackView = UIStackView().then {
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    fileprivate lazy var tempView1 = UIView().then {
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 10
    }
    
    fileprivate lazy var tempView2 = UIView().then {
        $0.backgroundColor = .systemCyan
        $0.layer.cornerRadius = 10
    }
    
    fileprivate lazy var tempView3 = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 10
    }
    
    fileprivate lazy var EnterButton = UIView().then {
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 20
    }
    
    fileprivate lazy var bottomView = UIStackView().then {
        $0.spacing = 5
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    fileprivate lazy var bottomText = UILabel().then {
        $0.text = "お困りですか？"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .darkGray
    }
    
    fileprivate lazy var bottomLink = UILabel().then {
        $0.text = "アカウントセンター"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .systemGreen
    }
    
    fileprivate lazy var bottomView2 = UIStackView().then {
        $0.spacing = 5
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    fileprivate lazy var bottomText2 = UILabel().then {
        $0.text = "アカウントがないですか？"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .darkGray
    }
    
    fileprivate lazy var bottomLink2 = UILabel().then {
        $0.text = "サインアップ"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .systemGreen
    }
    
    var disposeBag = DisposeBag()
    
    override func setProperty() {
        view.backgroundColor = .white
    }
    
    override func setLayout() {
        [titleLabel, inputField, toggleView, socialLoginStackView, EnterButton, bottomView, bottomView2].forEach {
            view.addSubview($0)
        }
        
        [emailInput, passwordInput].forEach {
            inputField.addArrangedSubview($0)
        }
        
        [toggleText, toggle].forEach {
            toggleView.addArrangedSubview($0)
        }
        
        [tempView1, tempView2, tempView3].forEach {
            socialLoginStackView.addArrangedSubview($0)
        }
        
        [bottomText, bottomLink].forEach {
            bottomView.addArrangedSubview($0)
        }
        
        [bottomText2, bottomLink2].forEach {
            bottomView2.addArrangedSubview($0)
        }
        
        
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        inputField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
        }

        toggleView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(inputField.snp.bottom).offset(30)
        }

        socialLoginStackView.snp.makeConstraints {
            $0.top.equalTo(toggleView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(200)
        }

        EnterButton.snp.makeConstraints {
            $0.top.equalTo(socialLoginStackView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }

        bottomView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(EnterButton.snp.bottom).offset(30)
        }

        bottomView2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bottomView.snp.bottom).offset(10)
        }
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

extension MainVC {
    
    fileprivate func createLabel(label: String, placeholder: String) -> UIStackView {
        let label = UILabel().then {
            $0.text = label
            $0.numberOfLines = 1
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            $0.textColor = .darkGray
        }

        let textField = UITextField().then {
            $0.placeholder = placeholder
            $0.font = .systemFont(ofSize: 13)
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 10
            UITextField.appearance().tintColor = .black
            $0.contentVerticalAlignment = .center
        }

        let textFieldBackground = UIView().then {
            $0.addSubview(textField)
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 10
        }

        let wapperView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 10
            $0.addArrangedSubview(label)
            $0.addArrangedSubview(textFieldBackground)
        }
        
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        
        textFieldBackground.snp.makeConstraints {
            $0.height.equalTo(50)
        }

        return wapperView
    }
}


// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct LoginVCPreview: PreviewProvider {
    static var previews: some View {
        return LoginVC().toPreview()
    }
}
#endif

