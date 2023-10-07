//
//  ProductDescriptionCVCell.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/10/06.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

/**
 *## description: 상품 상세설명 셀
 *## function : 상품상세설명 (추후 테그 추가 예정)
 */
final class ProductDescriptionCVCell: UICollectionViewCell {
    
    // 식별자 스태틱으로 선언
    static var identifier = "ProductDescriptionCVCell"
    // 디스포즈백
    public var disposeBag = DisposeBag()
    
    private lazy var descriptionLabel = UILabel(labelAprearance: .normal).then {
        $0.numberOfLines = 0
        $0.text =
        """
        2023년 4월 말에 구입
        
        - 아이패드 프로 5세대 M1 128기가 스페이스그레이입니다.
        - 외관 S급입니다. 기능 이상 없습니다.
        - 배터리효율 85퍼센트입니다.
        - 구성은 풀박스에 펜슬수납 가능 케이스 함께 드립니다.
        
        오늘(27일) 구입한 아이패드 미니6 와이파이버전 64기가 모델을 팝니다..
        오늘 쿠팡에서 새걸로 구입한 겁니다..

        박스 내용물 다 있습니다..
        바로 가져가실분 연락주세요..
        """
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(descriptionLabel)
    }
    
    private func setConstraint() {
        descriptionLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
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
struct ProductDescriptionCVCellPreview: PreviewProvider {
    static var previews: some View {
        return ProductDescriptionCVCell().toPreview().previewLayout(.fixed(width: 394, height: 300))
    }
}
#endif


