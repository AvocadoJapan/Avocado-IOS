//
//  BannerCC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import RxSwift
/**
 *## 화면명: 메인화면 배너 셀
 */
final class BannerCVCell: UICollectionViewCell, CollectionCellIdentifierable {
    typealias T = Banner
    static var identifier: String = "BannerCC"
    var disposeBag = DisposeBag()
    
    private var banner: Banner?
    
    private lazy var imageView = UIImageView().then {
        $0.backgroundColor = .systemGray6
        $0.image = UIImage(named: "demo_photo")
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        // setLayout
        addSubview(imageView)
        
        // setConstraint
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func config(banner: Banner) {
        self.banner = banner
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
