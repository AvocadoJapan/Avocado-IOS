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
        return LoginVC().toPreview()
    }
}
#endif

