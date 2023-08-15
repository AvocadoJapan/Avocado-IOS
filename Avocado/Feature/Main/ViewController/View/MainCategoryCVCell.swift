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
        $0.tintColor = .darkText
        $0.image = UIImage(systemName: "person.fill")
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.text = "가전제품"
        $0.font = UIFont.boldSystemFont(ofSize: 11)
        $0.textAlignment = .center
        $0.textColor = .darkText
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 4
    }
    
    override init(frame: CGRect) {
        let cellData = PublishSubject<MainCategory>()
        onData = cellData.asObserver()
        super.init(frame: frame)
        
        //setProporty
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 10
        
        //setLayout
        [iconImageView, nameLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        self.addSubview(stackView)
        
        //setConstraint
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.top.equalToSuperview().offset(10)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(iconImageView.snp.width)
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
        return MainCategoryCVCell().toPreview().previewLayout(.fixed(width: 60, height: 75))
    }
}
#endif
