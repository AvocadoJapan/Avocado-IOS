//
//  MainCategoryCC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import RxSwift
/**
 * ##화면 명: 메인화면 카테고리 셀
 */
final class MainCategoryCVCell: UICollectionViewCell, CollectionCellIdentifierable {
    typealias T = MainCategory
    static var identifier: String = "MainCategoryCC"
    var onData: AnyObserver<MainCategory>
    var disposeBag = DisposeBag()
    
    private lazy var iconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle")
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.text = "가전제품"
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        let cellData = PublishSubject<MainCategory>()
        onData = cellData.asObserver()
        super.init(frame: frame)
        
        //setLayout
        [iconImageView, nameLabel].forEach {
            addSubview($0)
        }
        
        //setConstraint
        iconImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        //bindUI
        cellData.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.iconImageView.image = UIImage(systemName: data.categoryImage)
                self?.nameLabel.text = data.categoryName
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct MainCategoryCCPreview:PreviewProvider {
    static var previews: some View {
        return MainCategoryCVCell().toPreview().previewLayout(.fixed(width: 60, height: 80))
    }
}
#endif
