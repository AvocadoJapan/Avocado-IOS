//
//  ProductCommentCVCell.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/03.
//

import UIKit

final class ProductCommentCVCell: UICollectionViewCell {
    static var identifier = "ProductCommentCVCell"
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.layer.cornerRadius = 16
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowRadius = 5
        $0.layer.masksToBounds = false
        $0.backgroundColor = .white
    }
    
    private lazy var commentLabel = PaddingLabel(padding: UIEdgeInsets(
        top: 10,
        left: 20,
        bottom:0,
        right: 20)
    ).then {
        $0.text = "\"...정말 서울에서 가까운곳에, 이렇게 독채로 즐길 수 있다는 곳이 있는게 너무 감사하고, 숙소에 구석구석 사장님이 세심하게 신경 써주신 것들이 다 느껴졌습니다.\""
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 4
        $0.textAlignment = .left
    }
    
    private lazy var userInfoLabel = PaddingLabel(padding: UIEdgeInsets(
        top: 0,
        left: 20,
        bottom: 0,
        right: 20)
    ).then {
        $0.text = "AvocadoDemo * 2023년 8월 21일 거래"
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .gray
        $0.numberOfLines = 1
    }
    
    private lazy var productContainerViewStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var productImageView = UIImageView().then {
        $0.image = UIImage(named: "cat_demo")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private lazy var productNameLabel = UILabel().then {
        $0.text = "필립스 휴 그라디언트 라이트 스트립 65인치"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray
    }
    
    private lazy var arrowButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [productImageView, productNameLabel, arrowButton].forEach {
            productContainerViewStackView.addArrangedSubview($0)
        }
        
        [commentLabel,
         userInfoLabel,
         productContainerViewStackView,].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        addSubview(containerStackView)
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        productImageView.snp.makeConstraints {
            $0.size.equalTo(30)
        }
        
        arrowButton.snp.makeConstraints {
            $0.width.equalTo(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(comment: String,
                   name: String,
                   creationDate: String,
                   productTitle: String) {
        commentLabel.text = "\"\(comment)\""
        userInfoLabel.text = "\(name) ・ \(creationDate)"
        productNameLabel.text = productTitle
    }
    
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct ProductCommentCVCellPreview: PreviewProvider {
    static var previews: some View {
        return ProductCommentCVCell().toPreview().previewLayout(.fixed(width: 300, height: 150))
    }
}
#endif
