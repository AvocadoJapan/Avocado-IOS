//
//  UserInfoStackView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/29.
//

import Foundation
import UIKit
import SnapKit

final class UserInfoView: UIView {
    
    private lazy var mainContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var profileContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var userStatusContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 60/2
        $0.clipsToBounds = true
        $0.backgroundColor = .systemGray5
        $0.image = UIImage(named: "cat_demo")
    }
    
    private lazy var userNameLabel = UILabel().then {
        $0.text = "호두믿음거래"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .darkText
        $0.textAlignment = .center
    }
    
    private lazy var userSingupDateLabel = UILabel().then {
        $0.text = "2023년 3월 10일 가입"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 8, weight: .regular)
        $0.textColor = .gray
        $0.textAlignment = .center
    }
    
    private lazy var userRoleLabel = UILabel().then {
        $0.text = "프리미엄 판매자"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 8, weight: .regular)
        $0.textColor = .gray
        $0.textAlignment = .center
    }
    
    private lazy var userRateLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private lazy var underLineView1 = ContourView(inset: UIEdgeInsets(top: 0,
                                                                     left: 20,
                                                                     bottom: 0,
                                                                     right: 20))
    
    private lazy var commentLabel = UILabel().then {
        $0.text = "후기"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setProperty()
        setConstraint()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.init(frame: .zero)
        setLayout()
        setProperty()
        setConstraint()
    }
    
    private func setProperty() {
        commentLabel.attributedText = NSMutableAttributedString()
            .bold(string: "\n", fontSize: 16)
            .regular(string: "후기", fontSize: 10)
        
        userRateLabel.attributedText = NSMutableAttributedString()
            .bold(string: "\n", fontSize: 16)
            .regular(string: "평점", fontSize: 10)
    }
    
    private func setLayout() {
        [profileImageView,
         userNameLabel,
         userSingupDateLabel,
         userRoleLabel].forEach {
            profileContainerView.addSubview($0)
        }
        
        [commentLabel,
         underLineView1,
         userRateLabel].forEach {
            userStatusContainerStackView.addArrangedSubview($0)
        }
        
        [profileContainerView,
         userStatusContainerStackView].forEach {
            mainContainerView.addSubview($0)
        }
        
        addSubview(mainContainerView)
    }
    
    private func setConstraint() {
        mainContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileContainerView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.bottom.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.centerY.equalToSuperview().offset(20)
            $0.left.right.equalToSuperview()
        }
        userRoleLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5)
            $0.left.right.equalToSuperview()
        }
        
        userSingupDateLabel.snp.makeConstraints {
            $0.top.equalTo(userRoleLabel.snp.bottom).offset(5)
            $0.left.right.equalToSuperview()
        }
        
        userStatusContainerStackView.snp.makeConstraints {
            $0.left.equalTo(profileContainerView.snp.right).offset(20)
            $0.right.equalToSuperview()
            $0.centerY.equalTo(profileContainerView)
        }
        
    }
    
    public func configure(name: String,
                          creationDate: String,
                          commentCount: Int,
                          userRate: Int) {
        userNameLabel.text = name
        userSingupDateLabel.text = creationDate
        
        commentLabel.attributedText = NSMutableAttributedString()
            .bold(string: "\(commentCount)\n", fontSize: 16)
            .regular(string: "후기", fontSize: 10)
        
        userRateLabel.attributedText = NSMutableAttributedString()
            .bold(string: "\(userRate)\n", fontSize: 16)
            .regular(string: "평점", fontSize: 10)
        
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct UserInfoStackViewPreview: PreviewProvider {
    static var previews: some View {
        return UserInfoView().toPreview().previewLayout(.fixed(width: 414, height: 150))
    }
}
#endif
