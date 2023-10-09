//
//  ProductTitleCVCell.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/10/06.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

/**
 *## description: 상품 상세화면에 사용할 제목 및 가격 셀
 *## function : 제목, 주소, 올린시간, 가격 포함
 */
final class ProductTitleCVCell: UICollectionViewCell {
    
    // 식별자 스태틱으로 선언
    static var identifier = "ProductTitleCVCell"
    // 디스포즈백
    public var disposeBag = DisposeBag()
    
    private lazy var titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
//        $0.layoutMargins = UIEdgeInsets(top: 0,
//                                        left: 20,
//                                        bottom: 0,
//                                        right: 20)
//        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var titleLabel = UILabel(labelAprearance: .header).then {
        $0.text = "아이패드 프로 12.9 5세대"
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 2
    }
    
    private lazy var titleSubInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
    }
    
    private lazy var locationLabel = UILabel(labelAprearance: .subtitle).then {
        $0.text = "서울특별시 성북구 안암동"
        $0.numberOfLines = 1
    }
    
    private lazy var dotLabel = UILabel(labelAprearance: .subtitle).then {
        $0.text = " ・ "
        $0.numberOfLines = 1
    }
    
    private lazy var updateAtLabel = UILabel(labelAprearance: .subtitle).then {
        $0.text = "20시간 전"
        $0.numberOfLines = 1
    }
    
    private lazy var priceLabel = UILabel(labelAprearance: .header).then {
        $0.text = "1,298,000원"
        $0.numberOfLines = 1
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
        addSubview(titleStackView)
        
        [titleLabel, titleSubInfoStackView, priceLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [locationLabel, dotLabel, updateAtLabel].forEach {
            titleSubInfoStackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraint() {
        locationLabel.setContentHuggingPriority(UILayoutPriority(751), for: .horizontal)
        dotLabel.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        updateAtLabel.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        
        titleStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(80)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct ProductTitleCVCellPreview: PreviewProvider {
    static var previews: some View {
        return ProductTitleCVCell().toPreview().previewLayout(.fixed(width: 394, height: 80))
    }
}
#endif
