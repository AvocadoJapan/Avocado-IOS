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

protocol CellClickEvent: AnyObject {
    
    
    func touchEvent(indexPath: Int)
}

/**
 * ##화면 명: 상품 셀
 */
final class ImageCVCell: UICollectionViewCell, CollectionCellIdentifierable {
    typealias T = Product
    static var identifier: String = "ImageCVCell"

    var disposeBag = DisposeBag()
    
    var indexPath: Int?
    
    weak var delegate: CellClickEvent?
    
    private lazy var productImageView = UIImageView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    public lazy var xButton = UIButton().then {
        let xSymbol = UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(xSymbol, for: .normal)
        $0.tintColor = .white
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        setLayout()
        setConstraints()
        
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(productImageView)
        addSubview(xButton)
    }
    
    private func setConstraints() {
        productImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(productImageView.snp.width)
        }
        
        xButton.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.size.equalTo(30)
        }
    }
    
    private func updateXButtonVisibility() {
        xButton.isHidden = (productImageView.image == nil)
    }

    func config(image: UIImage, indexPath: Int) {
        productImageView.image = image
        self.indexPath = indexPath
        xButton.tag = indexPath
        updateXButtonVisibility()
    }
    
    override func prepareForReuse() {
        productImageView.image = nil
        self.indexPath = nil
        updateXButtonVisibility()
    }
    
    @objc func xButtonTapped() {
//        productImageView.image = nil
//        self.indexPath = nil
//        updateXButtonVisibility()
        
        delegate?.touchEvent(indexPath: xButton.tag)
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


