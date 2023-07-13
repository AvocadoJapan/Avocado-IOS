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
    public var onData: AnyObserver<Banner>
    var disposeBag = DisposeBag()
    
    private lazy var imageView = UIImageView().then {
        $0.backgroundColor = .red
    }
    
    override init(frame: CGRect) {
        let cellData = PublishSubject<Banner>()
        onData = cellData.asObserver()
        
        super.init(frame: frame)
        // setLayout
        addSubview(imageView)
        
        // setConstraint
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        //bindUI
        cellData.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.imageView.image = UIImage(named: data.imageURL)
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
