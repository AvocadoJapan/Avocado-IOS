//
//  UserInfoStackView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/29.
//

import Foundation
import UIKit
import SnapKit
/**
 * - description 카드 형식으로 되어있는 유저 프로필 화면
 */
final class UserInfoCardView: UIView {
    
    private lazy var profileContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 10
    }
    private lazy var profileBadgeContainerView = UIView()
    private lazy var profileContainerView = UIView().then {
        $0.layer.cornerRadius = 16
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowColor = UIColor.black.cgColor // 색깔
        $0.layer.shadowRadius = 5 // 반경
        $0.layer.masksToBounds = false
        $0.backgroundColor = .white
    }
    private lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "cat_demo")
        $0.layer.cornerRadius = 120/2
        $0.layer.masksToBounds = true
    }
    private lazy var verifiedBadgeImageView = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.shield.fill")
        $0.tintColor = UIColor(hexCode: "00CC66", alpha: 1.0)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 80/2
    }
    private lazy var detailInfoContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
    }
    private lazy var commentLabel = UILabel().then {
        $0.attributedText = NSMutableAttributedString()
            .bold(string: "300 +\n", fontSize: 20)
            .regular(string: "후기", fontSize: 12)
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    private lazy var rateLabel = UILabel().then {
        $0.attributedText = NSMutableAttributedString()
            .bold(string: "4.9 +\n", fontSize: 20)
            .regular(string: "평점", fontSize: 12)
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    private lazy var roleLabel = UILabel().then {
        $0.attributedText = NSMutableAttributedString()
            .bold(string: "프리미엄\n", fontSize: 20)
            .regular(string: "등급", fontSize: 12)
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    private lazy var userNameLabel = UILabel().then {
        $0.text = "Avocado Demo"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .black
    }
    private lazy var userSignUpDateLabel = UILabel().then {
        $0.text = "2023년 8월 23일 가입"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    private lazy var underLineView1 = ContourView()
    private lazy var underLineView2 = ContourView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setProperty()
        setConstraint()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperty() {
        layer.cornerRadius = 16
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor // 색깔
        layer.shadowRadius = 5 // 반경
        layer.masksToBounds = false
        backgroundColor = .white
    }
    
    private func setLayout() {
        [commentLabel, underLineView1, rateLabel, underLineView2, roleLabel].forEach {
            detailInfoContainerStackView.addArrangedSubview($0)
        }
        
        [profileImageView, verifiedBadgeImageView].forEach {
            profileBadgeContainerView.addSubview($0)
        }
        
        [profileBadgeContainerView, userNameLabel, userSignUpDateLabel].forEach {
            profileContainerStackView.addArrangedSubview($0)
        }
        
        [profileContainerStackView, detailInfoContainerStackView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraint() {
        
        profileBadgeContainerView.snp.makeConstraints {
            $0.size.equalTo(120)
        }
        
        profileContainerStackView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        verifiedBadgeImageView.snp.makeConstraints {
            $0.centerX.equalTo(profileImageView).offset(40)
            $0.size.equalTo(40)
            $0.bottom.equalTo(profileImageView)
        }
        
        detailInfoContainerStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(profileContainerStackView)
            $0.left.greaterThanOrEqualTo(profileContainerStackView.snp.right).offset(20)
            $0.centerX.equalToSuperview().multipliedBy(1.5)
        }
        
    }
    
    public func configure(name: String,
                          creationDate: String,
                          commentCount: Int,
                          userRate: Double) {
        userNameLabel.text = name
        userSignUpDateLabel.text = creationDate
        
        commentLabel.attributedText = NSMutableAttributedString()
            .bold(string: "\(commentCount)\n", fontSize: 20)
            .regular(string: "후기", fontSize: 12)
        
        rateLabel.attributedText = NSMutableAttributedString()
            .bold(string: "\(userRate)\n", fontSize: 20)
            .regular(string: "평점", fontSize: 12)
        
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct UserInfoStackViewPreview: PreviewProvider {
    static var previews: some View {
        return UserInfoCardView().toPreview().previewLayout(.fixed(width: 414, height: 220))
    }
}
#endif
