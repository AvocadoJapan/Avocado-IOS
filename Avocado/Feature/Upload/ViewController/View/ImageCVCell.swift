//
//  ImageCVCell.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/30.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

/**
 * ##화면 명: 상품 셀
 */
final class ImageCVCell: UICollectionViewCell, CollectionCellIdentifierable {
    typealias T = Product
    static var identifier: String = "ImageCVCell"

    var disposeBag = DisposeBag()
    
    var indexPath: Int?
    
    private lazy var productImageView = UIImageView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    public lazy var deleteButton = UIButton().then {
        let xSymbol = UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(xSymbol, for: .normal)
        $0.tintColor = .white
        $0.isHidden = true
    }
    
    public var deleteButtonTapObservable: Observable<Void> {
        return deleteButton.rx.tap.asObservable()
    }
        
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        setLayout()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(productImageView)
        addSubview(deleteButton)
    }
    
    private func setConstraints() {
        productImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(productImageView.snp.width)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.size.equalTo(30)
        }
    }
    
    private func updateXButtonVisibility() {
        deleteButton.isHidden = (productImageView.image == nil)
    }

    func config(image: UIImage, indexPath: Int) {
        productImageView.image = image
        self.indexPath = indexPath
        deleteButton.tag = indexPath
        updateXButtonVisibility()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        indexPath = nil
        updateXButtonVisibility()
        disposeBag = DisposeBag()
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct ImageCVCellPreview: PreviewProvider {
    static var previews: some View {
        return ImageCVCell().toPreview().previewLayout(.fixed(width: 150, height: 150))
    }
}
#endif


