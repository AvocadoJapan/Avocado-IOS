//
//  UserProfileView.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/02.
//

import Foundation
/**
 * - description 유저 정보가 간략하게 보여지는 프로필 화면
 */
final class UserProfileView: UIControl {
    
    private lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "cat_demo")
        $0.layer.cornerRadius = 60/2
        $0.layer.masksToBounds = true
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.text = "Avocado Demo"
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    private lazy var detailLabel = UILabel().then {
        $0.text = "후기 300+ 평점 4.8"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray
    }
    
    private lazy var nameContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 15
    }
    
    private lazy var arrowButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .black
    }
    
    private lazy var verifiedImageView = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.shield.fill")
        $0.tintColor = UIColor(hexCode: "00CC66", alpha: 1.0)
        $0.layer.cornerRadius = 40/2
        $0.backgroundColor = .white
//        $0.image = UIImage(systemName: "exclamationmark.shield.fill")
//        $0.tintColor = UIColor(hexCode: "FF3333", alpha: 1.0)
    }
    
    /**
     * - description 화살표 화면을 showing 여부 함수
     * - parameters isShowArrow: 화살표 화면 showing 여부
     */
    init(isShowArrow: Bool = true) {
        super.init(frame: .zero)
        arrowButton.isHidden = !isShowArrow
        
        setLayout()
        setContraint()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setContraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [nameLabel, detailLabel].forEach {
            nameContainerStackView.addArrangedSubview($0)
        }
        
        [profileImageView, nameContainerStackView, arrowButton, verifiedImageView].forEach {
            addSubview($0)
        }
    }
    
    private func setContraint() {
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(60)
            $0.left.equalToSuperview().offset(20)
        }
        
        nameContainerStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(profileImageView.snp.right).offset(10)
        }
        
        arrowButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.size.equalTo(20)
            $0.centerY.equalToSuperview()
        }
        
        verifiedImageView.snp.makeConstraints {
            $0.centerX.equalTo(profileImageView.snp.centerX).offset(20)
            $0.bottom.equalTo(profileImageView.snp.bottom)
        }
    }
    
    /**
     * - description 화면 업데이트 함수
     */
    func configure(name: String,
                   verified: Bool = false) {
        nameLabel.text = name
        
        if verified {
            verifiedImageView.image = UIImage(systemName: "checkmark.shield.fill")
            verifiedImageView.tintColor = UIColor(hexCode: "00CC66", alpha: 1.0)
        }
        else {
            verifiedImageView.image = UIImage(systemName: "exclamationmark.shield.fill")
            verifiedImageView.tintColor = UIColor(hexCode: "FF3333", alpha: 1.0)
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct ProileViewPreview: PreviewProvider {
    static var previews: some View {
        return UserProfileView(isShowArrow: false).toPreview().previewLayout(.fixed(width: 414, height: 100))
    }
}
#endif
