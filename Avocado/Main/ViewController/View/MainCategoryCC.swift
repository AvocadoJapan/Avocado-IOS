//
//  MainCategoryCC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit

final class MainCategoryCC: UICollectionViewCell, CollectionCellIdentifierable {
    static var identifier: String = "MainCategoryCC"
    
    private lazy var iconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle")
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.text = "가전제품"
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [iconImageView, nameLabel].forEach {
            addSubview($0)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell() {
        
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct MainCategoryCCPreview:PreviewProvider {
    static var previews: some View {
        return MainCategoryCC().toPreview().previewLayout(.fixed(width: 60, height: 80))
    }
}
#endif
