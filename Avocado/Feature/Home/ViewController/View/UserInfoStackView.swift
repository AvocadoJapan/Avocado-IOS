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
        $0.image = UIImage(named: "cat_demo")
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.spacing = 20
    }
    
    // 유저이름, 가입년월 스택뷰
    private lazy var userNameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.spacing = 5
    }
    
    private lazy var userNameLabel = UILabel().then {
        $0.text = "호두믿음거래"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .darkText
    }
    
    private lazy var userSingupDateLabel = UILabel().then {
        $0.text = "2023년 3월 10일 가입"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .gray
    }
    
    private lazy var userRateLabel = UILabel().then {
        $0.text = "평점 4.78"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .gray
    }
    
    private lazy var userDescriptionLabel = UILabel().then {
        $0.text =
                """
                안녕하세요! 저는 다양한 물품을 저렴한 가격으로 판매하고 있는 판매자입니다. 여러 해 동안 수집한 아이템부터 최근에 구매한 제품까지 다양한 상품을 찾아보실 수 있습니다.
                
                저의 상점은 정성스럽게 관리된 상태의 제품들로 가득 차 있습니다. 모든 제품은 깨끗하게 관리되었으며, 특별한 하자나 문제가 없는지 신중하게 확인한 후 판매됩니다. 거래 과정에서 생기는 궁금한 점이나 우려 사항이 있다면 언제든지 메시지를 주시면 신속하게 답변해 드릴 것을 약속드립니다.
                
                더구나, 상품 가격에 대해서는 합리적으로 조정할 수 있습니다. 협상 가능한 여지가 있으니 원하시는 상품에 대해 자유롭게 가격 조율을 제안해 주세요. 최대한 상호 협의하여 양측 모두 만족할 수 있는 거래를 진행하고자 노력하고 있습니다.
                
                제 상점은 다양한 카테고리의 상품들로 가득 차 있습니다. 패션 아이템, 가전 제품, 책과 음악, 가구 및 가정용품 등을 다루고 있으며, 어떤 스타일에도 어울리는 다양한 제품을 제공하고자 합니다.
                """
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .gray
    }
    
    private lazy var moreButton = SubButton(text: "더보기").then {
        $0.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
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
        
        axis = .vertical
        alignment = .leading
        distribution = .fillProportionally
        spacing = 20
        
        addArrangedSubview(stackView)
        addArrangedSubview(userDescriptionLabel)
        addArrangedSubview(moreButton)
        
        [profileImageView, userNameStackView, uploaderBadgeStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [userNameLabel, userRateLabel, userSingupDateLabel].forEach {
            userNameStackView.addArrangedSubview($0)
        }
        
        [userBadge, userBadge1, userBadge2, userBadge3, userBadge4].forEach {
            uploaderBadgeStackView.addArrangedSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(60)
        }
        
        moreButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.init(frame: .zero)

        layoutMargins = inset
        isLayoutMarginsRelativeArrangement = true
    }
    
    @objc private func moreButtonTapped() {
        
    }
    
    public func configure(name: String,
                          creationDate: String) {
        userNameLabel.text = name
        userSingupDateLabel.text = creationDate
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct UserInfoStackViewPreview: PreviewProvider {
    static var previews: some View {
        return UserInfoStackView().toPreview().previewLayout(.fixed(width: 350, height: 250))
    }
}
#endif
