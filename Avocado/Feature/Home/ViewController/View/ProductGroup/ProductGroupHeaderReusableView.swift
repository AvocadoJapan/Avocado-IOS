//
//  ProductGroupHeaderReusableView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/24.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SnapKit
import RxCocoa

/**
 *## 화면명: 상품 그룹 해더 ReusableView (그룹 이름 라벨)
 */
final class ProductGroupHeaderReusableView: UICollectionReusableView {
    
    static var identifier = "ProductGroupHeaderRV"
    
    private var sectionId: String?
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .black
        $0.text = "알 수 없는 오류"
        $0.textAlignment = .left
        $0.contentMode = .center
    }
    
    private lazy var moreButton: SubButton = SubButton(text: "MORE".localized(), fontSize: 14, weight: .bold)
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, moreButton].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }

        moreButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProperty(title: String, id: String? = nil) {
        titleLabel.text = title
        sectionId = id
    }
}
