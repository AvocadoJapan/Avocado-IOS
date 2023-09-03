//
//  ProfileHeaderReusableView.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import UIKit

final class ProfileHeaderReusableView: UICollectionReusableView {
    static var identifier = "ProfileHeaderReusableView"
    // 전체 화면을 담을 스택 뷰
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    // 유저 정보 화면
    private lazy var userCardView = UserInfoCardView()
    // 거래희망 장소 라벨
    private lazy var faivortePayLocationLabel = UILabel().then {
        $0.attributedText = NSMutableAttributedString()
            .regular(string: "거래를 선호하는 지역은\n", fontSize: 16)
            .bold(string: "경기도 화성시 정남면", fontSize: 20)
            .regular(string: "입니다", fontSize: 16)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    // 본인인증 타이틀
    private lazy var userVerifiedTitleLabel = UILabel().then {
        $0.text = "Avocado Demo의 인증 정보"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    // 본인인증 종류를 담을 스택 뷰
    private lazy var userVerfiedContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    // 본인인증 종류 화면 {이메일, 주소 등등..}
    private lazy var verifiedEmailCheckView = CheckedView(title: "이메일 주소")
    // 구분선
    private lazy var underLineView = ContourView()
    private lazy var underLineView2 = ContourView()
    // 상품 정보를 넣을 스택뷰
    private lazy var productContainerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    // 상품 제목
    private lazy var productTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .black
        $0.text = "알 수 없는 오류"
        $0.textAlignment = .left
        $0.contentMode = .center
    }
    // 더보기 버튼
    private lazy var moreButton = SubButton(
        text: "MORE".localized(),
        fontSize: 14,
        weight: .bold
    )
    
    private lazy var userProfileConatainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        // 상품 정보
        [productTitleLabel, moreButton].forEach {
            productContainerStackView.addArrangedSubview($0)
        }
        
        // 본인인증 종류
        [verifiedEmailCheckView].forEach {
            userVerfiedContainerStackView.addArrangedSubview($0)
        }
        
        // 유저 정보
        [userCardView,
         faivortePayLocationLabel,
         underLineView,
         userVerifiedTitleLabel,
         userVerfiedContainerStackView,
         underLineView2].forEach {
            userProfileConatainerStackView.addArrangedSubview($0)
        }
        
        // 유저정보, 상품 정보 넣기
        [userProfileConatainerStackView,
         productContainerStackView].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        addSubview(containerStackView)
        
    }
    
    private func setConstraint() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        userVerfiedContainerStackView.subviews.forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(40)
            }
        }
       
    }
    /**
     * - description 화면 업데이트 함수
     */
    func configure(userName: String,
                   location: String,
                   creationDate: String,
                   commentCount: Int,
                   userRate: Double,
                   productTitle: String = "") {
        
        userCardView.configure(
            name: userName,
            creationDate: creationDate,
            commentCount: commentCount,
            userRate: userRate
        )
        
        userVerifiedTitleLabel.text = "\(userName)의 인증정보"
        
        faivortePayLocationLabel.attributedText = NSMutableAttributedString()
            .regular(string: "거래를 선호하는 지역은\n", fontSize: 16)
            .bold(string: "\(location)", fontSize: 20)
            .regular(string: "입니다", fontSize: 16)
        
        productTitleLabel.text = productTitle
        
    }
    
    /**
     * - description isProfile 변수에 따라 상품정보를 보여줄지 말지 설정하는 메서드
     * - parameters isProfile: 상품정보 화면 show 여부
     */
    func changedMode(isProfile: Bool) {
        userProfileConatainerStackView.isHidden = !isProfile
        productContainerStackView.isHidden = isProfile
    }
    
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct ProfileHeaderReusableViewPreview: PreviewProvider {
    static var previews: some View {
        return ProfileHeaderReusableView().toPreview().previewLayout(.fixed(width: 375, height: 700))
    }
}
#endif
