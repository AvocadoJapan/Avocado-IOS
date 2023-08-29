//
//  ProfileSettingVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/04.
//

import UIKit
import SnapKit
import RxCocoa
import RxRelay
import RxSwift
import Then
import PhotosUI
import RxKeyboard


final class ProfileSettingVC: BaseVC {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "프로필 설정"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
        $0.backgroundColor = .systemGray5
    }
    
    private lazy var profileButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "default_profile"), for: .normal)
        $0.addTarget(self, action: #selector(didTapImageView), for: .touchUpInside)
        $0.imageView?.contentMode = .scaleAspectFill

    }
    
    private lazy var profileView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 60
        $0.layer.masksToBounds = true
    }
    
    private lazy var profileLabel = UILabel().then {
        $0.isUserInteractionEnabled = false
        $0.text = "Edit"
        $0.backgroundColor = .white
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.alpha = 0.7
        $0.font = .boldSystemFont(ofSize: 12)
    }
    
    
    private lazy var nameInput = InputView(label: "닉네임", placeholder: "Nickname", colorSetting: .normal)
    
    private lazy var confirmButton = BottomButton(text: "확인")
    
    var viewModel: ProfileSettingVM
    
    init(vm viewModel: ProfileSettingVM) {
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
        [profileButton, profileLabel].forEach {
            self.profileView.addSubview($0)
        }
        
        [titleLabel, profileImageView, nameInput, confirmButton, profileView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraint() {
        
        profileView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.height.width.equalTo(120)
        }
        
        profileButton.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        profileLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        nameInput.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileView.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
    }
    
    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        
        //MARK: - INPUT BINDING
        nameInput
            .userInput
            .bind(to: viewModel.input.nickNameInputRelay)
            .disposed(by: disposeBag)
        
        confirmButton
            .rx
            .tap
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(onNext: { [weak self] void in
                self?.viewModel.input.actionProfileSetUpRelay.accept(void)
                /* mocking
                let user = User(userId: "asd", nickName: "asdasd", updateAt: 123, createdAt: 123, accounts: Accounts(cognito: ""), avatar: Avatar(id: "asd", changedAt: 1234))
                self?.viewModel.steps.accept(AuthStep.loginIsComplete(user: user)) */
            })
            .disposed(by: disposeBag)
        
        //MARK: - OUTPUT BINDING
        output.successSignUpeRelay
            .asSignal()
            .emit(onNext: { [weak self] _ in
                self?.viewModel.steps.accept(AuthStep.loginIsComplete)
            })
            .disposed(by: disposeBag)
            
        output.errEventPublish
            .asSignal()
            .emit(onNext: { [weak self] err in
                let alert = UIAlertController(title: "", message: err.errorDescription , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                
                self?.present(alert, animated: true)
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
    
    // MARK: - 커스텀 메소드
    @objc private func didTapImageView() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
}

extension ProfileSettingVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let result = results.first else { return }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            if let error = error {
                print("Failed to load image: \(error)")
                return
            }

            // 이미지 데이터 형식으로 변환 및 사용자 이미지 show
            // 사용자 이미지 resizing
            if let image = object as? UIImage,
               let imageData = image.resize(width: 120).jpegData(compressionQuality: 1.0) {
                self?.profileButton.rx.image(for: .normal).onNext(image.resize(width: 120))
                self!.viewModel.input.selectedImageDataRelay.accept(imageData)
            }
        }
    }
}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct ProfileSettingVCPreview: PreviewProvider {
    static var previews: some View {
        return ProfileSettingVC(vm: ProfileSettingVM(service: AuthService(), regionid: "", s3Service: S3Service())).toPreview()
    }
}
#endif
