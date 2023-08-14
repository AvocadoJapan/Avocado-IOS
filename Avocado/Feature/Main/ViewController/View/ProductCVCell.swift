import UIKit
import RxSwift

/**
 * ##화면 명: 상품 셀
 */
final class ProductCVCell: UICollectionViewCell, CollectionCellIdentifierable {
    typealias T = Product
    static var identifier: String = "ProductCC"
    var onData: AnyObserver<Product>
    var disposeBag = DisposeBag()
    
    private lazy var productImageView = UIImageView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "demo_product")
    }
    private lazy var productNameLabel = UILabel().then {
        $0.text = "아이패드 프로 12.9 5세대"
        $0.textColor = .darkGray
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
    private lazy var priceLabel = UILabel().then {
        $0.text = "123,456원"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    private lazy var locationLabel = UILabel().then {
        $0.text = "영등포구 여의동"
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .lightGray
    }
    
    override init(frame: CGRect) {
        let cellData = PublishSubject<Product>()
        onData = cellData.asObserver()
        
        super.init(frame: frame)
        setLayout()
        setConstraints()
        setProperties()
        bindUI(cellData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [productImageView, productNameLabel, priceLabel, locationLabel].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        productImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(productImageView.snp.width)
        }
        
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(5)
            $0.left.right.equalTo(productImageView)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(10)
            $0.left.right.equalTo(productImageView)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(5)
            $0.left.right.equalTo(productImageView)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setProperties() {
        productNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        locationLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    private func bindUI(_ cellData: PublishSubject<Product>) {
        cellData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.productNameLabel.text = data.name
                self?.productImageView.image = UIImage(named: data.imageURL)
                self?.locationLabel.text = data.location
                self?.priceLabel.text = data.price
            })
            .disposed(by: disposeBag)
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
