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
    fileprivate lazy var titleLabel = UILabel().then {
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
    
    private lazy var emailInput = InputView(label: "닉네임", placeholder: "Nickname", colorSetting: .normal)
    
    private lazy var confirmButton = BottomButton(text: "확인")
    
    var disposeBag = DisposeBag()
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
    }
    
    override func setLayout() {
        [titleLabel, profileImageView, emailInput, confirmButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview().offset(30)
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.size.equalTo(100)
        }
        
        emailInput.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(20)
        }
    }
    
    override func bindUI() {
        viewModel.selectedImageSubject
            .bind(to: profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: {
                self.confirmButton.keyboardMovement(from:self.view, height: $0)
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

            if let image = object as? UIImage {

                self!.viewModel.selectedImageSubject.onNext(image)

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
        return ProfileSettingVC(vm: ProfileSettingVM()).toPreview()
    }
}
#endif
