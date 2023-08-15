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
import Localize_Swift

final class WelcomeVC: BaseVC {
    
    private lazy var logo = UIImageView().then {
        $0.image = UIImage(named: "logo_avocado")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "아보카도를 이용하기 위해서는 로그인이 필요합니다".localized()
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    private lazy var signupButton: SubButton = SubButton(text: "아직 계정이 없나요? 회원가입".localized())
    
    private lazy var agreementLabel = UILabel().then {
        $0.text = "로그인을 함으로써, 당사 약관 및 개인정보 정책에 동의한 것으로 간주합니다".localized()
        $0.numberOfLines = 0
        $0.textAlignment = .right
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
    
    private lazy var socialLoginButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    
    private lazy var appleLogin = UIButton().then {
        $0.setTitle("Apple로 계속하기".localized(), for: .normal)
        $0.backgroundColor = .white
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        
        let appleLogo = UIImage(named: "btn_apple")
        $0.setImage(appleLogo, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        
        $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: -20, bottom: 12, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    private lazy var googleLogin = UIButton().then {
        $0.setTitle("Google로 계속하기".localized(), for: .normal)
        $0.backgroundColor = .white
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        
        let googleLogo = UIImage(named: "btn_google")
        $0.setImage(googleLogo, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        
        $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: -15, bottom: 12, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }
    
    private lazy var avocadoLogin = BottomButton(text: "이메일로 로그인".localized())
    
    private let viewModel: WelcomeVM
    
    init(viewModel: WelcomeVM) {
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
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalTo(agreementLabel.snp.top).offset(-10)
        }
        
        agreementLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(socialLoginButtonStackView.snp.top).offset(-20)
            $0.left.equalToSuperview().offset(30)
        }
        
        socialLoginButtonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(170)
        }
    }
    
    override func bindUI() {
        // 구글 로그인
        googleLogin
            .rx
            .tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.socialLoginWithGoogle(view: self.view)
            })
            .disposed(by: disposeBag)
        
        // 애플 로그인
        appleLogin
            .rx
            .tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.socialLoginWithApple(view: self.view)
            }
            .disposed(by: disposeBag)
        
        // 이메일 로그인
        avocadoLogin
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.viewModel.handleAvocadoLogin()
            })
            .disposed(by: disposeBag)
        
        // 회원가입
        signupButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.viewModel.handleSignup()
            })
            .disposed(by: disposeBag)
        
        // 소셜 로그인 성공 여부
        viewModel.successEventPublish
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                self?.steps.accept(AuthStep.loginIsComplete(user: user))
            })
            .disposed(by: disposeBag)
        
        //소셜 로그인 에러 여부
        viewModel.errEventPublish
            .asSignal()
            .emit(onNext:{ [weak self] err in
                switch err {
                case .pageNotFound:
                    
                    let alert = UIAlertController(title: "", message: "사용자가 존재하지 않습니다\n 아보카도 회원가입 먼저 부탁드립니다", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "확인", style: .default,handler: { _ in
                        let authService = AuthService()
                        let signUpVM = SignUpVM(service: authService)
                        let signUPVC = SignupVC(viewModel: signUpVM)
                        self?.navigationController?.pushViewController(signUPVC, animated: true)
                    }))
                    
                    self?.present(alert, animated: true)
                    
                case .unknown(_, let message):
                    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    
                    self?.present(alert, animated: true)
                    
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}



// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct WelcomeVCPreview: PreviewProvider {
    static var previews: some View {
        return WelcomeVC(viewModel: WelcomeVM(service: AuthService())).toPreview()
    }
}
#endif
