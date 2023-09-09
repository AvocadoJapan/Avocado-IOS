//
//  RecentSearchCVCell.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/09.
//

import UIKit

final class RecentSearchCVCell: UICollectionViewCell {

    static var identifier = "RecentSearchCVCell"
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 0,
            right: 10
        )
        $0.isLayoutMarginsRelativeArrangement = true
        
        $0.layer.borderColor = UIColor.systemGray6.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private lazy var searchContentLabel = UILabel().then {
        $0.text = "아이폰 12프로 맥스"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .black
        
    }
    
    private lazy var deleteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .gray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [searchContentLabel, deleteButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        addSubview(containerStackView)
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        deleteButton.snp.makeConstraints {
            $0.width.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(content: String) {
        searchContentLabel.text = content
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct RecentSearchCVCellPreview: PreviewProvider {
    static var previews: some View {
        return RecentSearchCVCell()
            .toPreview()
            .previewLayout(
                .fixed(width: 200, height: 50)
            )
    }
}
#endif
