//
//  PhotoScrollHeaderRV.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/10/05.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SnapKit
import RxCocoa

/**
 *## 화면명: 상품 상세화면에 사용할 컴포시셔널뷰 해더, 상품사진을 가로스크롤 할 수 있음
 *## 기능 : 상품사진은 8개까지, 사진을 누르면 확대가능화면으로 이동
 */
final class PhotoScrollHeaderRV: UICollectionReusableView {
    
    // 식별자 스태틱으로 선언
    static var identifier = "PhotoScrollHeaderViewRV"
    // 디스포즈백
    public var disposeBag = DisposeBag()
    
    private lazy var productPhotoCVLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    private lazy var productPhotoCV = UICollectionView(frame: .zero, collectionViewLayout: self.productPhotoCVLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .systemYellow
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperty() {
        
        // productPhotoCV 델리게이트설정
        productPhotoCV.delegate = self
        productPhotoCV.dataSource = self
        productPhotoCV.register(ProductImageCVCell.self,
                                forCellWithReuseIdentifier: ProductImageCVCell.identifier)
    }
    
    private func setLayout() {
        addSubview(productPhotoCV)
    }
    
    private func setConstraint() {
        productPhotoCV.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

extension PhotoScrollHeaderRV: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCVCell.identifier, for: indexPath) as! ProductImageCVCell
        return cell
    }
}

extension PhotoScrollHeaderRV: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct PhotoScrollHeaderViewRVPreview: PreviewProvider {
    static var previews: some View {
        return PhotoScrollHeaderRV().toPreview().previewLayout(.fixed(width: 394, height: 394))
    }
}
#endif

