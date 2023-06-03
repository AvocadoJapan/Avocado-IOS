//
//  BannerCC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit

final class BannerCC: UICollectionViewCell, CollectionCellIdentifierable {
    static var identifier: String = "BannerCC"
    
    private lazy var imageView = UIImageView().then {
        $0.backgroundColor = .red
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell() {
    
    }
    
}
