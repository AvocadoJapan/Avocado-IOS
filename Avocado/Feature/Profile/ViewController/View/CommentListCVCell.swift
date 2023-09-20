//
//  CommentListCVCell.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/18.
//

import UIKit
import RxSwift

final class CommentListCVCell: UICollectionViewCell {

    static let identifier = "CommentListCVCell"
    
    private lazy var mainContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 20
        )
        $0.isLayoutMarginsRelativeArrangement = true
    }
    private lazy var productContainerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    private lazy var profileContainerView = UIView()
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
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "cat_demo")
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
    }
    private lazy var nameLabel = UILabel().then {
        $0.text = "호두마루"
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textColor = .black
    }
    private lazy var createDateLabel = UILabel().then {
        $0.text = "2023.09.18"
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .gray
    }
    private lazy var commentLabel = UILabel().then {
        $0.text = "번창하세요"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
    }
    private lazy var contourView = ContourView()
    
    var disposeBag = DisposeBag()
    var productDetailTapObservable: Observable<Void> {
        return arrowButton.rx.tap.asObservable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [imageView, nameLabel, createDateLabel].forEach {
            profileContainerView.addSubview($0)
        }
        
        [productImageView, productNameLabel, arrowButton].forEach {
            productContainerStackView.addArrangedSubview($0)
        }
        
        [profileContainerView, commentLabel, productContainerStackView, contourView].forEach {
            mainContainerStackView.addArrangedSubview($0)
        }
        
        addSubview(mainContainerStackView)
        
        imageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
            $0.size.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(imageView.snp.right).offset(10)
            $0.top.equalTo(imageView.snp.top).offset(10)
            $0.right.equalToSuperview().offset(10)
        }
        
        createDateLabel.snp.makeConstraints {
            $0.left.equalTo(nameLabel.snp.left)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        // 하단 상품 버튼
        productImageView.snp.makeConstraints {
            $0.size.equalTo(30)
        }
        
        arrowButton.snp.makeConstraints {
            $0.width.equalTo(20)
        }
        
        mainContainerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(comment: String,
                   name: String,
                   creationDate: String,
                   productTitle: String) {
        commentLabel.text = comment
        nameLabel.text = name
        createDateLabel.text = creationDate
        productNameLabel.text = productTitle
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct CommentListCVCellPreview: PreviewProvider {
    static var previews: some View {
        return CommentListCVCell()
            .toPreview()
            .previewLayout(
                .fixed(
                    width: 414,
                    height: 180
                )
            )
    }
}
#endif
