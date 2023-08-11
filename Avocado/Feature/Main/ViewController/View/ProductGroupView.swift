//
//  ProductGroupView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/12.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxFlow

// FIXME: 추후 RxCocoa 를 이용한 바인딩 추가해야됨

final class ProductGroupView: UIView {
    
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .black
        $0.text = "한국어 데모"
        $0.textAlignment = .left
        $0.contentMode = .center
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let width = (self.frame.width / 3 == 0) ? (400 - 42) / 3 : (self.frame.width - 42) / 3

        layout.itemSize = CGSize(width: width, height: 200)
        
//        layout.minimumInteritemSpacing = 5 // 셀 간 수평 간격
//        layout.minimumLineSpacing = 5 // 셀 간 수직 간격
        layout.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7) // 섹션 내부 마진
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCVCell.self, forCellWithReuseIdentifier: ProductCVCell.identifier)
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    lazy var moreButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 10
//        $0.layer.borderColor = UIColor.darkGray.cgColor
//        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = true
    }
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(moreButton)
        
        // 제약 조건 설정
        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ProductGroupView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6 // 6개의 셀
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCVCell.identifier, for: indexPath)
        //        cell.backgroundColor = .blue
        return cell
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct ProductGroupViewPreview: PreviewProvider {
    static var previews: some View {
        return ProductGroupView().toPreview().previewLayout(.fixed(width: 400, height: 540))
    }
}
#endif
