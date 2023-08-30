//
//  ProfileHeaderReusableView.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import UIKit

final class ProfileHeaderReusableView: UICollectionReusableView {
    static var identifier = "ProfileHeaderReusableView"
    
    private lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "default_profile")
        $0.layer.cornerRadius = 35
        $0.layer.masksToBounds = true
    }
    
    private lazy var userNameLabel = UILabel().then {
        $0.text = "Avocado Test User"
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    private lazy var creationDateLabel = UILabel().then {
        $0.text = "2023년 8월 29일 가입"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .lightGray
    }
    
    private lazy var descriptionContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    private lazy var userGradeLabel = UILabel().then {
        $0.text = "⭐ 프리미엄 판매자"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .lightGray
    }
    
    private lazy var userVerifiedLabel = UILabel().then {
        $0.text = "⚠️ 본인인증 미완료"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .lightGray
    }
    
    private lazy var questionButton = UIButton().then {
        $0.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        $0.tintColor = .lightGray
    }
    
    private lazy var counterView = ContourView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [userGradeLabel, userVerifiedLabel].forEach {
            descriptionContainerStackView.addArrangedSubview($0)
        }
        
        [profileImageView, userNameLabel, creationDateLabel, descriptionContainerStackView, questionButton, counterView].forEach {
            addSubview($0)
        }
        
    }
    
    private func setConstraint() {
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
            $0.size.equalTo(70)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top).offset(15)
            $0.left.equalTo(profileImageView.snp.right).offset(10)
        }
        
        creationDateLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(10)
            $0.left.right.equalTo(userNameLabel)
        }
        
        descriptionContainerStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(userNameLabel.snp.right).offset(30)
            $0.right.greaterThanOrEqualToSuperview().inset(60)
        }
        
        questionButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(8)
        }
        
        counterView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func configure(userName: String, grade: String, verified: String, creationDate: String) {
        userNameLabel.text = userName
        userGradeLabel.text = grade
        userVerifiedLabel.text = verified
        creationDateLabel.text = creationDate
    }
    
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct ProfileHeaderReusableViewPreview: PreviewProvider {
    static var previews: some View {
        return ProfileHeaderReusableView().toPreview().previewLayout(.fixed(width: 375, height: 100))
    }
}
#endif
