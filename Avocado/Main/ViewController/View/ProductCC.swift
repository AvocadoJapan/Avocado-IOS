//
//  MainCC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit

final class ProductCC: UICollectionViewCell, CollectionCellIdentifierable {
    
    static var identifier: String = "ProductCC"
    
    private lazy var productImageView = UIImageView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    private lazy var productNameLabel = UILabel().then {
        $0.text = "Panasonic"
        $0.font = UIFont.boldSystemFont(ofSize: 12)
    }
    private lazy var priceLabel = UILabel().then {
        $0.text = "￥3000000"
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    private lazy var locationLabel = UILabel().then {
        $0.text = "東京都渋谷区"
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .lightGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        [productImageView, productNameLabel, priceLabel, locationLabel].forEach {
            addSubview($0)
        }
        
        productImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(productImageView.snp.width)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(10)
            $0.left.equalTo(productImageView).offset(8)
            $0.right.equalTo(productImageView)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(5)
            $0.left.right.equalTo(productImageView)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(5)
            $0.left.right.equalTo(productImageView)
            $0.bottom.equalToSuperview()
        }
        productNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        locationLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell() {
        
    }
    
    
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct ProductCCPreview:PreviewProvider {
    static var previews: some View {
        return ProductCC().toPreview().previewLayout(.fixed(width: 150, height: 220))
    }
}
#endif
