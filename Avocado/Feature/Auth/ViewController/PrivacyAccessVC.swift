//
//  PrivacyAccessVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/06.
//

import UIKit
import SnapKit
import RxCocoa
import RxRelay
import RxSwift
import Then
import PhotosUI
import RxKeyboard

final class PrivacyAccessVC: BaseVC {
    private lazy var titleLabel = UILabel().then {
        $0.text = "개인 정보 액세스"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "아보카도 이용을 위해 다음 권한의 허용이 필요합니다."
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
    
    private let notificationElement = PrivacyElementView(type: .notification, require: false)
    
    private let locationElement = PrivacyElementView(type: .location, require: false)
    
    private let calendarsElement = PrivacyElementView(type: .calendars, require: false)
    
    private let microphoneElement = PrivacyElementView(type: .microphone, require: false)
    
    private let cameraElement = PrivacyElementView(type: .camera, require: false)
    
    private let photoElement = PrivacyElementView(type: .photos, require: false)
    
    private lazy var confirmButton = BottomButton(text: "다음")
    
    override func setProperty() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func setLayout() {
        [notificationElement, locationElement, calendarsElement, microphoneElement, cameraElement, photoElement, locationElement].forEach {
            self.stackView.addArrangedSubview($0)
        }
        
        [titleLabel, descriptionLabel, stackView, confirmButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraint() {
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
    }
    
    override func bindUI() {
    }
}


// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct PrivacyAccessVCPreview: PreviewProvider {
    static var previews: some View {
        return PrivacyAccessVC().toPreview()
    }
}
#endif
