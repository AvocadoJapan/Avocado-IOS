//
//  WelcomeVC.swift
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

class WelcomeVC: BaseVC {
    
    fileprivate lazy var logo = UIImageView().then {
        $0.image = UIImage(named: "logo_avocado")
        $0.contentMode = .scaleAspectFit
    }
    
    fileprivate lazy var titleLabel = UILabel().then {
        $0.text = "아보카도를 이용하기 위해서는 로그인이 필요합니다"
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    
    
    private lazy var signupButton : SubButton = SubButton(text: "아직 계정이 없나요? 회원가입")
    
    fileprivate lazy var agreementLabel = UILabel().then {
        $0.text = "로그인을 함으로써, 당사 약관 및 개인정보 정책에 동의한 것으로 간주합니다"
        $0.numberOfLines = 0
        $0.textAlignment = .right
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
    
    fileprivate lazy var socialLoginButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 10
    }


    
    fileprivate lazy var appleLogin = UIButton().then {
        $0.setTitle("Apple로 계속하기", for: .normal)
        $0.backgroundColor = .white
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 0.7
        
        let googleLogo = UIImage(named: "btn_apple")
        $0.setImage(googleLogo, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        
        $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: -20, bottom: 12, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    fileprivate lazy var googleLogin = UIButton().then {
        $0.setTitle("Google로 계속하기", for: .normal)
        $0.backgroundColor = .white
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 0.7
        
        let googleLogo = UIImage(named: "btn_google")
        $0.setImage(googleLogo, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        
        $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: -15, bottom: 12, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }

    
    fileprivate lazy var avocadoLogin = UIButton().then {
        $0.setTitle("이메일로 로그인", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        $0.layer.cornerRadius = 20
    }
    
    var disposeBag = DisposeBag()
    let viewModel: WelcomeVM
    
    init(vm: WelcomeVM) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setProperty() {
        view.backgroundColor = .white
    }
    
    override func setLayout() {
        [logo, titleLabel, signupButton, agreementLabel, socialLoginButtonStackView].forEach {
            view.addSubview($0)
        }
        
        [appleLogin, googleLogin, avocadoLogin].forEach {
            socialLoginButtonStackView.addArrangedSubview($0)
        }
        
    }
    
    override func setConstraint() {
        
        logo.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.equalToSuperview().offset(30)
            $0.size.equalTo(55)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logo.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(30)
        }
        
        signupButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(agreementLabel.snp.top).offset(-10)
            $0.left.equalToSuperview().offset(30)
        }
        
        agreementLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(socialLoginButtonStackView.snp.top).offset(-20)
            $0.left.equalToSuperview().offset(30)
        }

        socialLoginButtonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(170)
        }

    }
    
    override func bindUI() {
        googleLogin
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.socialLoginWithGoogle(view: self.view)
            })
            .disposed(by: disposeBag)
        
        appleLogin
            .rx
            .tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.socialLoginWithApple(view: self.view)
            }
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



// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct WelcomeVCPreview: PreviewProvider {
    static var previews: some View {
        return WelcomeVC(vm: WelcomeVM(service: AuthService())).toPreview()
    }
}
#endif
