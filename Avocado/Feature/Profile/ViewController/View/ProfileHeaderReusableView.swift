//
//  ProfileHeaderReusableView.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import UIKit

final class ProfileHeaderReusableView: UICollectionReusableView {
    static var identifier = "ProfileHeaderReusableView"
    
    private lazy var profileContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    private lazy var questionButton = UIButton().then {
        $0.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        $0.tintColor = .lightGray
    }
    
    private lazy var underLineView = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    private lazy var userProfileView = UserInfoStackView(inset: UIEdgeInsets(
        top: 0,
        left: 10,
        bottom: 0,
        right: 10)
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        
        [userProfileView, underLineView].forEach {
            profileContainerStackView.addArrangedSubview($0)
        }
        
        addSubview(questionButton)
        addSubview(profileContainerStackView)
        
    }
    
    private func setConstraint() {
        
        questionButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(8)
        }
        
        profileContainerStackView.snp.makeConstraints {
            $0.top.equalTo(questionButton.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints {
            $0.height.equalTo(30)
        }

    }
    
    func configure(userName: String,
                   creationDate: String) {
        
        userProfileView.configure(
            name: userName,
            creationDate: creationDate
        )
    }
    
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct ProfileHeaderReusableViewPreview: PreviewProvider {
    static var previews: some View {
        return ProfileHeaderReusableView().toPreview().previewLayout(.fixed(width: 375, height: 270))
    }
}
#endif
