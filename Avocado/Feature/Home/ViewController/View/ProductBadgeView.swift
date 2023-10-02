//
//  ProductBadgeView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/26.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class ProductBadgeView: UIView {
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "bolt_solid")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 5
    }
    
    private lazy var titleLabel = UILabel(labelAprearance: .title).then{
        $0.numberOfLines = 1
        $0.text = "알 수 없는 오류"
    }
    
    private lazy var descriptionLabel = UILabel(labelAprearance: .subtitle).then{
        $0.numberOfLines = 2
        $0.text = "오류가 발생했어요"
    }
    
    private lazy var mainStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mainStackView)
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
        
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(labelStackView)
        
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(self.snp.height).dividedBy(1.7)
        }
        
        mainStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: ProductBadge) {
        self.init(frame: .zero)
        
        titleLabel.text = type.title
        descriptionLabel.text = type.buyerDescription
        imageView.image = UIImage(named: "\(type.image)")
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct ProductBadgeViewPreview: PreviewProvider {
    static var previews: some View {
        return ProductBadgeView().toPreview().previewLayout(.fixed(width: 300, height: 50))
    }
}
#endif

