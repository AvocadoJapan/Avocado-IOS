//
//  UserBadgeView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/29.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class UserBadgeView: UIView {
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "bolt_solid")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var mainStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "프리미엄 판매자"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .gray
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(titleLabel)
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(15)
        }
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: UserBadge) {
        self.init(frame: .zero)
        
        titleLabel.text = type.description
        imageView.image = UIImage(named: "\(type.image)")
        
        if type == .unverified {
            titleLabel.textColor = .systemRed
        }
        
        if type == .verified {
            titleLabel.textColor = .systemGreen
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct UserBadgeViewPreview: PreviewProvider {
    static var previews: some View {
        return UserBadgeView().toPreview().previewLayout(.fixed(width: 130, height: 30))
    }
}
#endif


