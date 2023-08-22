//  ProductGroupCVCell.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/12.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxFlow

// FIXME: 추후 RxCocoa 를 이용한 바인딩 추가해야됨

final class ProductGroupCVCell: UICollectionViewCell, CollectionCellIdentifierable {

    typealias T = Product
    static var identifier: String = "ProductGroupCVCell"
    var disposeBag = DisposeBag()
    
    private var productSection: ProductSection?

    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .black
        $0.text = "알 수 없는 오류"
        $0.textAlignment = .left
        $0.contentMode = .center
    }

    let flowLayout = UICollectionViewFlowLayout().then {
        $0.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.register(ProductCVCell.self, forCellWithReuseIdentifier: ProductCVCell.identifier)
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
    }

    lazy var moreButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, collectionView, moreButton].forEach {
            contentView.addSubview($0)
        }
        
        // Set Constraints
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
        moreButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flowLayout.itemSize = CGSize(width: self.frame.width/3 - 12, height: 200)
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    func config(productSection: ProductSection) {
        self.productSection = productSection
        
        titleLabel.text = productSection.name
    }
    
    override func prepareForReuse() {
        self.productSection = nil
    }
}

extension ProductGroupCVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productSection?.products.count ?? 0 // 6개의 셀
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCVCell.identifier, for: indexPath) as! ProductCVCell
        
        if let product = productSection?.products[indexPath.row] {
            cell.config(product: product)
        } else {
            // Handle the case where the product is nil or productSection is nil.
            // You might want to configure the cell with some default values or handle it differently.
        }
        
        return cell
    }
}


#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct ProductGroupCVCellPreview: PreviewProvider {
    static var previews: some View {
        return ProductGroupCVCell().toPreview().previewLayout(.fixed(width: 400, height: 540))
    }
}
#endif
