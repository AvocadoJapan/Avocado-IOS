//
//  SearchResultCVCell.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/14.
//

import UIKit

final class SearchResultCVCell: UICollectionViewCell {
    
    static let identifier = "SearchResultCVCell"
    
    private lazy var productImageView = UIImageView().then {
        $0.image = UIImage(named: "cat_demo")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 5
    }
    
    private lazy var productTitleLabel = UILabel().then {
        $0.text = "아이패드 프로 3세대"
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    private lazy var productCategoryLabel = UILabel().then {
        $0.text = "iPad"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray
    }
    
    private lazy var productLocationLabel = UILabel().then {
        $0.text = "서울특별시 성북구 안암동 ・ 1시간 전"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray
    }
    
    private lazy var productPriceLabel = UILabel().then {
        $0.text = "1,298,000"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [productTitleLabel, productCategoryLabel, productLocationLabel, productPriceLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        [productImageView, containerStackView].forEach {
            addSubview($0)
        }
        
        productImageView.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview().inset(10)
            $0.width.equalTo(self.snp.height).offset(-20)
        }
        
        containerStackView.snp.makeConstraints {
            $0.left.equalTo(productImageView.snp.right).offset(10)
            $0.top.bottom.right.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, category: String, location: String, price: Int64) {
        productTitleLabel.text = title
        productCategoryLabel.text = category
        productLocationLabel.text = location
        productPriceLabel.text = price.decimalString()
    }
    
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct SearchResultCVCellPreview: PreviewProvider {
    static var previews: some View {
        return SearchResultCVCell()
            .toPreview()
            .previewLayout(
                .fixed(
                    width: 414,
                    height: 110
                )
            )
    }
}
#endif
