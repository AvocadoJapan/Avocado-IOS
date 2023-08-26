//
//  SingleProductVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/19.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

/**
 *##화면 명: Avocado 메인화면 (배너, 카테고리 별 상품 정보를 확인가능)
 */
final class SingleProductVC: BaseVC {
    
    private var viewModel: SingleProductVM
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.delegate = self
    }
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30
    }
    
    private lazy var productImageCVLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    private lazy var productImageCV = UICollectionView(frame: .zero, collectionViewLayout: self.productImageCVLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
    }
    
    private lazy var titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "아이패드 프로 6세대 11인치 128기가 셀룰러 미개봉"
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 19, weight: .bold)
        $0.textColor = .darkText
    }
    
    private lazy var titleSubInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
    }
    
    private lazy var locationLabel = UILabel().then {
        $0.text = "서울특별시 성북구 안암동"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .gray
    }
    
    private lazy var dotLabel = UILabel().then {
        $0.text = " ・ "
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .darkGray
    }
    
    private lazy var updateAtLabel = UILabel().then {
        $0.text = "20시간 전"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .gray
    }
    
    private lazy var priceLabel = UILabel().then {
        $0.text = "1,298,000원"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .darkText
    }
    
    private lazy var uploaderStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = 20
    }
    
    private lazy var uploaderNameStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.spacing = 5
    }
    
    private lazy var uploaderInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillEqually
        $0.spacing = 5
    }
    
    private lazy var userSingupDateLabel = UILabel().then {
        $0.text = "2023년 3월 10일 가입"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .gray
    }
    
    
    private lazy var starRateLabel = UILabel().then {
        $0.text = "⭐️ 프리미엄 판매자"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .gray
    }
    
    private lazy var reviewLabel = UILabel().then {
        $0.text = "💬 거래후기 345"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .gray
    }
    
    private lazy var userCertificateLabel = UILabel().then {
        $0.text = "⚠️ 본인 인증 미완료"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .systemRed
    }
    
    private lazy var uploaderNameLabel = UILabel().then {
        $0.text = "번개장터 킬러"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .darkText
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 60/2
        $0.clipsToBounds = true
        $0.backgroundColor = .systemGray5
    }
    
    private lazy var bottomView = UIView().then {
        $0.backgroundColor = .white
    }
    
    
    private lazy var buttomButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .fillProportionally
    }
    private lazy var purchaseButton = BottomButton(text: "결제하기", buttonType: .primary)
    private lazy var dmButton = BottomButton(text: "DM보내기", buttonType: .secondary)
    
    private lazy var descriptionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .leading
    }
    
    private lazy var productBadgeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 15
        $0.distribution = .fillEqually
    }
    
    private lazy var productBadgeDemo = ProductBadgeView(type: .avocadoPay)
    private lazy var productBadgeDemo2 = ProductBadgeView(type: .business)
    private lazy var productBadgeDemo3 = ProductBadgeView(type: .fastShipping)
//    private lazy var productBadgeDemo4 = ProductBadgeView(type: .freeShipping)
//    private lazy var productBadgeDemo5 = ProductBadgeView(type: .handmade)
//    private lazy var productBadgeDemo6 = ProductBadgeView(type: .premiumSeller)
//    private lazy var productBadgeDemo7 = ProductBadgeView(type: .refundable)
//    private lazy var productBadgeDemo8 = ProductBadgeView(type: .unused)
//    private lazy var productBadgeDemo9 = ProductBadgeView(type: .verified)
    
    private lazy var descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14.5, weight: .regular)
        $0.textColor = .darkGray
        $0.text =
        """
        【状態】使用感なく非常に綺麗です。

        出品する理由
        最新のPro12.9インチを購入したため
        11インチの方を使用していなかったので！
        出品させて頂きました。

        2023/04末に購入

        【商品説明】
        ・定価：148,800円
        ・ストレージ：128GB
        ・ネットワーク：Wi-Fi＋セルラー
        ・色：スペースグレー

        【同梱物】
        ・11インチiPad Pro
        ・USB-C充電ケーブル(未使用)
        ・USB-C電源アダプタ(未使用)


        すり替え防止のため、返品・交換・返金不可
        よろしくお願いします。

        購入後に即フィルムとケースを着用し2ヶ月程の使用ですがキズ等なく非常に良い状態です。

        フィルムは着けたまま発送させて頂きます。
        ケースは多少の使用感ございますがご希望でしたらお付け致します。
        """
    }
    
    private let legalView = LegalView()
    
    init(viewModel: SingleProductVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setViewDidLoad() {
        // 초기 메인데이터 API call]
        viewModel.input.actionViewDidLoad.accept(())
        //        scrollView.refreshControl = refreshControl
    }
    
    override func setProperty() {
        view.backgroundColor = .white
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Configure productImageCV
        productImageCV.delegate = self
        productImageCV.dataSource = self
        productImageCV.register(ProductImageCVCell.self, forCellWithReuseIdentifier: ProductImageCVCell.identifier)
    }
    
    override func setLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        [dmButton, purchaseButton].forEach {
            buttomButtonStackView.addArrangedSubview($0)
        }
        
        [productImageCV, titleStackView, uploaderStackView, productBadgeStackView, descriptionStackView, legalView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [productBadgeDemo, productBadgeDemo2, productBadgeDemo3
        // , productBadgeDemo4, productBadgeDemo5, productBadgeDemo6, productBadgeDemo7, productBadgeDemo8, productBadgeDemo9
        ].forEach {
            productBadgeStackView.addArrangedSubview($0)
        }
        
        [titleLabel, titleSubInfoStackView, priceLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [profileImageView, uploaderNameStackView, uploaderInfoStackView].forEach {
            uploaderStackView.addArrangedSubview($0)
        }
        
        [uploaderNameLabel, userSingupDateLabel].forEach {
            uploaderNameStackView.addArrangedSubview($0)
        }
        
        [starRateLabel, reviewLabel, userCertificateLabel].forEach {
            uploaderInfoStackView.addArrangedSubview($0)
        }
        
        [locationLabel, dotLabel, updateAtLabel].forEach {
            titleSubInfoStackView.addArrangedSubview($0)
        }
        
        [descriptionLabel].forEach {
            descriptionStackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraint() {
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        productImageCV.snp.makeConstraints {
            $0.height.equalTo(self.view.snp.width)
            $0.width.equalTo(self.view.snp.width)
        }
        
        titleStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        uploaderStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
//        uploaderNameStackView.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//        }
        
        uploaderInfoStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        descriptionStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        productBadgeDemo.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(60)
        }
    }
}

extension SingleProductVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCVCell.identifier, for: indexPath) as! ProductImageCVCell
        
        return cell
    }
}

extension SingleProductVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

//extension SingleProductVC: UIScrollViewDelegate {
//    // MARK: - UIScrollViewDelegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let yOffset = scrollView.contentOffset.y
//        if yOffset > 50 {
//            navigationController?.setNavigationBarHidden(false, animated: true) // 네비게이션바 표시
//        } else {
//            navigationController?.setNavigationBarHidden(true, animated: true) // 네비게이션바 숨기기
//        }
//    }
//}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift

struct SingleProductVCPreview: PreviewProvider {
    static var previews: some View {
        let sampleProduct = Product(
            productId: "sample",
            mainImageId: "sample",
            imageIds: ["sample", "sample2", "sample3"],
            name: "sample",
            price: "sample",
            location: "sample"
        )
        
        let viewModel = SingleProductVM(service: MainService(), product: sampleProduct)
        
        return UINavigationController(rootViewController: SingleProductVC(viewModel: viewModel)).toPreview()
    }
}
#endif
