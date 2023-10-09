//
//  SectionTitleReusableView.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/09.
//  Modified by Jayden Jang on 2023/10/09.
//

import UIKit
/**
 * - description collectionView section에 타이틀만 존재하는 UICollectionReusableView
 */
final class SectionTitleReusableView: UICollectionReusableView {
    
    static var identifier = "SectionTitleReusableView"
    
    private lazy var titleLabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.boldSystemFont(ofSize: 25)
        $0.numberOfLines = 0
        $0.textColor = .black
    }
    
    init(font: UIFont, padding: UIEdgeInsets) {
        super.init(frame: .zero)
        
        titleLabel.font = font
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(padding)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(
                UIEdgeInsets(
                    top: 0,
                    left: 20,
                    bottom: 0,
                    right: 20
                )
            )
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String,
//                   font: UIFont = UIFont.boldSystemFont(ofSize: 25),
                   labelAprearance: AvocadoLabel = .sectionTitle,
                   padding: UIEdgeInsets = UIEdgeInsets(
                    top: 0,
                    left: 20,
                    bottom: 0,
                    right: 20
                   )
    ) {
        titleLabel.text = title
        titleLabel.font = labelAprearance.font
        titleLabel.textColor = labelAprearance.color
        titleLabel.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(padding)
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct SectionTitleReusableViewPreview: PreviewProvider {
    static var previews: some View {
        return SectionTitleReusableView()
            .toPreview()
            .previewLayout(.fixed(width: 300,
                                  height: 50))
    }
}
#endif
