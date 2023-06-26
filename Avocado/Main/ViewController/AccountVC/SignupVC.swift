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
    
    private lazy var emailInput : InputView = InputView(label: "이메일", placeholder: " example@example.com", colorSetting: .normal)
    
    private lazy var passwordInput : InputView = InputView(label: "비밀번호", placeholder: "********", colorSetting: .normal)
    
    private lazy var passwordCheckInput : InputView = InputView(label: "비밀번호 확인", placeholder: "********", colorSetting: .normal)
    
    private lazy var nicknameInput : InputView = InputView(label: "닉네임", placeholder: "username", colorSetting: .normal)
    
        
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
    
//    fileprivate lazy var bottomButtonStackView = UIStackView().then {
//        $0.axis = .horizontal
//        $0.alignment = .fill
//        $0.distribution = .fillEqually
//        $0.spacing = 10
//    }
//    
//    fileprivate lazy var backButton = UIButton().then {
//        $0.setTitle("ログインに戻る", for: .normal)
//        $0.backgroundColor = .gray
//        $0.setTitleColor(.white, for: .normal)
//        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
//        $0.layer.cornerRadius = 25
//    }
    
    fileprivate lazy var confirmButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        $0.layer.cornerRadius = 20
    }
    
    var disposeBag = DisposeBag()
    
    override func setProperty() {
        view.backgroundColor = .white
    }
    
    override func setLayout() {
        [titleLabel, inputField, toggleView, confirmButton].forEach {
            view.addSubview($0)
        }
        
        [emailInput, passwordInput, passwordCheckInput, nicknameInput].forEach {
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
            $0.horizontalEdges.equalToSuperview().offset(30)
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
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(50)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func handleUserInputFromMainVC(_ sender: UITextField){
        print(#fileID, #function, #line, "- sender: \(sender.text ?? "")")
    }
}


// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct SignupVCPreview: PreviewProvider {
    static var previews: some View {
        return SignupVC().toPreview()
    }
}
#endif
