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
    
    private lazy var mainContrainerView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .black
    }
    
    private lazy var profileContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "cat_demo")
        $0.layer.cornerRadius = 50/2
        $0.layer.masksToBounds = true
    }
    
    private lazy var profileImageControlView = UIControl().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var userNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = .white
        $0.text = "호두마루 님"
    }
    
    private lazy var creationDateLabel = UILabel().then {
        $0.textColor = .systemGray6
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = "2022.10.09 가입"
    }
    
    private lazy var titleView = UIView().then {
        $0.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .white
    }
    
    private lazy var titleLabel = PaddingLabel(
        padding: UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 0
        )
    ).then {
        $0.font = UIFont.systemFont(
            ofSize: 16,
            weight: .bold
        )
        $0.textColor = .black
        $0.text = "알 수 없는 오류"
        $0.textAlignment = .left
    }
    
    var disposeBag = DisposeBag()
    
    var profileImageControlViewTapObservable: Observable<Void> {
        return profileImageControlView.rx.controlEvent(.touchUpInside)
            .asObservable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupLayout()
        setConstraint()
    }
    
    private func setupLayout() {
        profileImageControlView.addSubview(profileImageView)
        titleView.addSubview(titleLabel)
        
        [creationDateLabel, userNameLabel, profileImageControlView].forEach {
            profileContainerView.addSubview($0)
        }
        
        [profileContainerView, titleView].forEach {
            mainContrainerView.addArrangedSubview($0)
        }
        
        addSubview(mainContrainerView)
    }
    
    private func setConstraint() {
     
        userNameLabel.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(20)
        }
        
        creationDateLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(8)
            $0.left.equalTo(userNameLabel)
        }
        
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        profileImageControlView.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.top)
            $0.right.equalToSuperview().inset(20)
            $0.size.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleView.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        mainContrainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(userName: String,
                   creationDate: String,
                   settingTitle: String) {
        userNameLabel.text = userName
        creationDateLabel.text = creationDate
        titleLabel.text = settingTitle
    }
    
    func changeMode(isShowProfile: Bool = false) {
        profileContainerView.isHidden = !isShowProfile
        titleView.layer.cornerRadius = !isShowProfile ? 0 : 16
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
//@available(iOS 17, *)
//#Preview(traits: .fixedLayout(width: 414, height: 200)) {
//    ProfileHeaderReusableView()
//}
#endif


