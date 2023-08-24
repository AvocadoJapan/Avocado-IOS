//
//  ProductImageCVCell.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/22.
//

import UIKit
import RxSwift
/**
 *## 화면명: 단일 상품, 상품 이미지 셀ㅇ
 */
final class ProductImageCVCell: UICollectionViewCell, CollectionCellIdentifierable {
    typealias T = UIImage
    static var identifier: String = "ProductImageCVCell"
    public var onData: AnyObserver<UIImage>
    var disposeBag = DisposeBag()
    
    private lazy var imageView = UIImageView().then {
        $0.backgroundColor = .systemGray6
        $0.image = UIImage(named: "demo_product_ipad")
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        let cellData = PublishSubject<UIImage>()
        onData = cellData.asObserver()
        
        super.init(frame: frame)
        // setLayout
        addSubview(imageView)
        
        // setConstraint
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        //bindUI
        cellData.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.imageView.image = UIImage(named: "demo_product")
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
