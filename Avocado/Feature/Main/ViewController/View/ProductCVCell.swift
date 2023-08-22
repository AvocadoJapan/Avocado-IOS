import UIKit
import RxSwift
import RxRelay
import RxCocoa

/**
 * ##화면 명: 상품 셀
 */
final class ProductCVCell: UICollectionViewCell, CollectionCellIdentifierable {
    typealias T = Product
    static var identifier: String = "ProductCC"

    var disposeBag = DisposeBag()
    
    let productSelectedRelay = PublishRelay<Void>()
    
    private var product: Product?
//    
//    private var title: String?
//    private var price: String?
//    private var location: String?
//    private var productId: String?
    
    private lazy var productImageView = UIImageView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "demo_product")
    }
    private lazy var productTitleLabel = UILabel().then {
        $0.text = product?.name
        $0.textColor = .darkGray
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
    private lazy var priceLabel = UILabel().then {
        $0.text = product?.price
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    private lazy var locationLabel = UILabel().then {
        $0.text = product?.location
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .lightGray
    }
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        setLayout()
        setConstraints()
        setProperties()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [productImageView, productTitleLabel, priceLabel, locationLabel].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        productImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(productImageView.snp.width)
        }
        
        productTitleLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(5)
            $0.left.right.equalTo(productImageView)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(10)
            $0.left.right.equalTo(productImageView)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(productTitleLabel.snp.bottom).offset(5)
            $0.left.right.equalTo(productImageView)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setProperties() {
        productTitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        locationLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    func config(product: Product) {
        self.product = product
        
//        productTitleLabel.text = product.name
//        // FIXME: 나중에 실제 image 로 대치해야함
////        productImageView.image = product?.name
//        locationLabel.text = product.name
//        priceLabel.text = product.price
    }
    
    @objc private func handleTap() {
       productSelectedRelay.accept(())
   }
    
    override func prepareForReuse() {
        self.product = nil
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct ProductCCPreview: PreviewProvider {
    static var previews: some View {
        return ProductCVCell().toPreview().previewLayout(.fixed(width: 150, height: 220))
    }
}
#endif
