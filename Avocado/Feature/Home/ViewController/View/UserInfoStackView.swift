//
//  UserInfoStackView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/29.
//

import Foundation
import UIKit
import SnapKit

final class UserInfoStackView: UIStackView {
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 60/2
        $0.clipsToBounds = true
        $0.backgroundColor = .systemGray5
    }
    
    // 유저이름, 가입년월 스택뷰
    private lazy var userNameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.spacing = 5
    }
    
    private lazy var userNameLabel = UILabel().then {
        $0.text = "최애의 카르마"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .darkText
    }
    
    private lazy var userSingupDateLabel = UILabel().then {
        $0.text = "2023년 3월 10일 가입"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .gray
    }
    
    
    // 유저 배지 스택뷰
    private lazy var uploaderBadgeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    // 유저 배지
    private lazy var userBadge = UserBadgeView(type: .comment(number: 239))
    private lazy var userBadge1 = UserBadgeView(type: .premiumBuyer)
    private lazy var userBadge2 = UserBadgeView(type: .premiumSeller)
    private lazy var userBadge3 = UserBadgeView(type: .unverified)
    private lazy var userBadge4 = UserBadgeView(type: .verified)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        alignment = .leading
        distribution = .fill
        spacing = 20
        
        [profileImageView, userNameStackView, uploaderBadgeStackView].forEach {
            addArrangedSubview($0)
        }
        
        [userNameLabel, userSingupDateLabel].forEach {
            userNameStackView.addArrangedSubview($0)
        }
        
        [userBadge, userBadge1, userBadge2, userBadge3, userBadge4].forEach {
            uploaderBadgeStackView.addArrangedSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(60)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(user: User) {
        self.init(frame: .zero)

        
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct UserInfoStackViewPreview: PreviewProvider {
    static var previews: some View {
        return UserInfoStackView().toPreview().previewLayout(.fixed(width: 450, height: 250))
    }
}
#endif
