//
//  MainCC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import RxSwift
/**
 * ##화면 명: 상품 셀
 */
final class ProductCC: UICollectionViewCell, CollectionCellIdentifierable {
    typealias T = Product
    static var identifier: String = "ProductCC"
    var onData: AnyObserver<Product>
    var disposeBag = DisposeBag()
    
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
        let cellData = PublishSubject<Product>()
        onData = cellData.asObserver()
        
        super.init(frame: frame)
        //setLayout
        [productImageView, productNameLabel, priceLabel, locationLabel].forEach {
            addSubview($0)
        }
        //setConstraint
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
            $0.top.equalTo(priceLabel.snp.bottom)
            $0.left.right.equalTo(productImageView)
            $0.bottom.equalToSuperview()
        }
        
        //setProperty
        productNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        locationLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        //bindUI
        cellData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.productNameLabel.text = data.name
                self?.productImageView.image = UIImage(named: data.imageURL)
                self?.locationLabel.text = data.location
                self?.priceLabel.text = data.price
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
