//
//  ProfileHeaderReusableView.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import UIKit

final class ProfileHeaderReusableView: UICollectionReusableView {
    static var identifier = "ProfileHeaderReusableView"
    
    private lazy var mainContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
    }
    
    private lazy var profileContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
        $0.layoutMargins = UIEdgeInsets(top: 20,
                                        left: 0,
                                        bottom: 0,
                                        right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var productContainerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.layoutMargins = UIEdgeInsets(top: 0,
                                        left: 10,
                                        bottom: 0,
                                        right: 10)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var productTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .black
        $0.text = "알 수 없는 오류"
        $0.textAlignment = .left
        $0.contentMode = .center
    }
    
    private lazy var moreButton = SubButton(text: "MORE".localized(),
                                            fontSize: 14,
                                            weight: .bold)
    
    private lazy var underLineView = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    
    private lazy var userProfileView = UserProfileView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        // 상품 헤더 세팅
        [productTitleLabel, moreButton].forEach {
            productContainerStackView.addArrangedSubview($0)
        }
        
        // 프로필 정보 세팅
        [userProfileView, underLineView].forEach {
            profileContainerStackView.addArrangedSubview($0)
        }
        
        // 메인 컨테이너 세팅
        [profileContainerStackView, productContainerStackView].forEach {
            mainContainerStackView.addArrangedSubview($0)
        }
        
        addSubview(mainContainerStackView)
        
    }
    
    private func setConstraint() {
        
        mainContainerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        productContainerStackView.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        underLineView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
    }
    
    func configure(userName: String,
                   creationDate: String,
                   productTitle: String = "") {
        
        userProfileView.configure(
            name: userName,
            verified: true
        )
        
        productTitleLabel.text = productTitle
    }
    
    func changedMode(isProfile: Bool) {
        profileContainerStackView.isHidden = !isProfile
        productContainerStackView.isHidden = isProfile
    }
    
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct ProfileHeaderReusableViewPreview: PreviewProvider {
    static var previews: some View {
        return ProfileHeaderReusableView().toPreview().previewLayout(.fixed(width: 375, height: 200))
    }
}
#endif
