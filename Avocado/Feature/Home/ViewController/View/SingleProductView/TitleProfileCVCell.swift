//
//  TitleProfileCVCell.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/10/08.
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
final class TitleProfileCVCell: UICollectionViewCell {
    
    // 식별자 스태틱으로 선언
    static var identifier = "ProductTitleCVCell"
    // 디스포즈백
    public var disposeBag = DisposeBag()
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    private lazy var contourView = ContourView()
    
    // MARK: - 상품 타이틀
    private lazy var titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
        $0.layoutMargins = UIEdgeInsets(top: 0,
                                        left: 20,
                                        bottom: 0,
                                        right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
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
    
    // MARK: - 업로더 프로필
    
    private lazy var profileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        
        $0.layoutMargins = UIEdgeInsets(top: 0,
                                        left: 20,
                                        bottom: 0,
                                        right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "cat_demo")
        $0.layer.cornerRadius = 45/2
        $0.layer.masksToBounds = true
    }
    
    private lazy var nameLabel = UILabel(labelAprearance: .title).then {
        $0.text = "Avocado Demo"
    }
    
    private lazy var detailLabel = UILabel(labelAprearance: .subtitle).then {
        $0.text = "후기 300+ 평점 4.8"
    }
    
    private lazy var nameContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 5
    }
    
    private lazy var arrowButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .black
    }
    
    private lazy var verifiedImageView = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.shield.fill")
        $0.tintColor = UIColor(hexCode: "00CC66", alpha: 1.0)
        $0.layer.cornerRadius = 45/2
        $0.backgroundColor = .white
    }
    
    /**
     * - description 화살표 화면을 showing 여부 함수
     * - parameters isShowArrow: 화살표 화면 showing 여부
     */
    init(isShowArrow: Bool = true) {
        super.init(frame: .zero)
        arrowButton.isHidden = !isShowArrow
        
        setLayout()
        setContraint()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        setContraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
//        addSubview(titleStackView)
        addSubview(stackView)
        
        [titleStackView, contourView, profileStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [titleLabel, titleSubInfoStackView, priceLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [locationLabel, dotLabel, updateAtLabel].forEach {
            titleSubInfoStackView.addArrangedSubview($0)
        }
        
        [profileImageView, nameContainerStackView, arrowButton].forEach {
            profileStackView.addArrangedSubview($0)
        }
        
        [nameLabel, detailLabel].forEach {
            nameContainerStackView.addArrangedSubview($0)
        }
    }
    
    private func setContraint() {
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(45)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.width.equalTo(20)
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
struct TitleProfileCVCellPreview: PreviewProvider {
    static var previews: some View {
        return TitleProfileCVCell().toPreview().previewLayout(.fixed(width: 394, height: 150))
    }
}
#endif


