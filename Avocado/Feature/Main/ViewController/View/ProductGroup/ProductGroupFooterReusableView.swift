//
//  ProductGroupFooterReusableView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/24.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

/**
 *## 화면명: 상품 그룹 푸터 ReusableView (더보기 버튼)
 *## 누를 경우 이펙트: 그 상품그룹의 ID 값으로 6개가 아닌 전체 정보를 보여주는 VC로 이동
 */
final class ProductGroupFooterReusableView: UICollectionReusableView {
    
    static var identifier = "ProductGroupFooterRV"
    
    private lazy var moreButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        moreButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
