//
//  CatecogyCVCell.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/14.
//

import UIKit

final class CatecogyCVCell: UICollectionViewCell {
    static let identifier = "CatecogyCVCell"
    
    let titleLabel = PaddingLabel(padding:UIEdgeInsets(
        top: 10,
        left: 10,
        bottom: 10,
        right: 10)
    ).then {
        $0.text = "iphone 13"
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.textColor = UIColor(hexCode: "4d7c0f")
        $0.backgroundColor = UIColor(hexCode: "ecfccb")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.right.left.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct CatecogyCVCellPreview: PreviewProvider {
    static var previews: some View {
        return CatecogyCVCell()
            .toPreview()
            .previewLayout(
                .fixed(
                    width: 100,
                    height: 40
                )
            )
    }
}
#endif
