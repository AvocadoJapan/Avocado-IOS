//
//  ProfileHeaderReusableView.swift
//  Avocado
//
//  Created by NUNU:D on 2023/10/09.
//

import UIKit
import RxSwift

final class ProfileHeaderReusableView: UICollectionReusableView {
    static var identifier = "ProfileHeaderReusableView"
    
    private lazy var backgroundInsetView = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    
    private lazy var profileContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    private lazy var mainContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 20
    }
    
    private lazy var userCardView = UserProfileView()
    
    private lazy var titleLabel = PaddingLabel(
        padding: UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 0
        )
    ).then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .black
        $0.text = "알 수 없는 오류"
        $0.textAlignment = .left
        $0.contentMode = .bottom
    }
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [userCardView, backgroundInsetView].forEach {
            profileContainerStackView.addArrangedSubview($0)
        }
        
        [profileContainerStackView, titleLabel].forEach {
            mainContainerStackView.addArrangedSubview($0)
        }
        
        addSubview(mainContainerStackView)
        
        mainContainerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        userCardView.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        
        backgroundInsetView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(userName: String,
                   description: String,
                   settingTitle: String,
                   verified: Bool) {
        
        userCardView.configure(
            name: userName,
            verified: verified
        )
        
        titleLabel.text = settingTitle
    }
    
    func changeMode(isShowProfile: Bool = false) {
        profileContainerStackView.isHidden = !isShowProfile
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct ProfileHeaderReusableViewPreview: PreviewProvider {
    static var previews: some View {
        return ProfileHeaderReusableView()
            .toPreview()
            .previewLayout(
                .fixed(
                    width: 414,
                    height: 200
                )
            )
    }
}
#endif
