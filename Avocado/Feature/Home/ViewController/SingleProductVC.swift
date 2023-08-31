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
        $0.spacing = 20
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
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        $0.isLayoutMarginsRelativeArrangement = true
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

    private lazy var uploaderStackView = UserInfoStackView(inset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    
    // 하단 고정뷰 (좋아요 채팅, 결제 등)
    private lazy var bottomView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var contourView = ContourView()
    private lazy var contourView2 = ContourView(inset: UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40))
    private lazy var contourView3 = ContourView(inset: UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40))
    private lazy var contourView4 = ContourView(inset: UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40))
    
    private lazy var buttomButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.backgroundColor = .white
    }
    private lazy var favButton = BottomButton(text: "좋아요", buttonType: .info)
    private lazy var purchaseButton = BottomButton(text: "결제하기", buttonType: .primary)
    private lazy var dmButton = BottomButton(text: "채팅하기", buttonType: .secondary)
    
    private lazy var descriptionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .leading
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var productBadgeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 15
        $0.distribution = .fillEqually
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        $0.isLayoutMarginsRelativeArrangement = true
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
        2023년 4월 말에 구입
        
        - 아이패드 프로 5세대 M1 128기가 스페이스그레이입니다.
        - 외관 S급입니다. 기능 이상 없습니다.
        - 배터리효율 85퍼센트입니다.
        - 구성은 풀박스에 펜슬수납 가능 케이스 함께 드립니다.
        - 일산 직거래, 그 외 지역 택배거래합니다.
        - 편하게 문의주세요.
        
        
        오늘(27일) 구입한 아이패드 미니6 와이파이버전 64기가 모델을 팝니다..
        오늘 쿠팡에서 새걸로 구입한 겁니다..

        게임용도로만 쓰려고 구입한건데, 문제는 제가 아이패드류는 처음써보는 거라는 겁니다..
        안드로이드만 써 오다가 애플제품 한번 질러본건데
        뒤로가기도 모르겠고 게임을 실행해도 그래서 게임종료도 못하겠고
        짜증만 나고 화딱지만 나네요..

        그래서 바로 방출하렵니다..

        상태는 당연히 100프로 수준이고 강화유리 바로 붙였습니다..

        박스 내용물 다 있습니다..
        바로 가져가실분 연락주세요..
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
        view.backgroundColor = .white
        
        // Configure productImageCV
        productImageCV.delegate = self
        productImageCV.dataSource = self
        productImageCV.register(ProductImageCVCell.self, forCellWithReuseIdentifier: ProductImageCVCell.identifier)
    }
    
    override func setLayout() {
        view.addSubview(scrollView)
        view.addSubview(bottomView)
        scrollView.addSubview(stackView)
        
        bottomView.addSubview(buttomButtonStackView)
        bottomView.addSubview(contourView)
        
        [favButton, dmButton, purchaseButton].forEach {
            buttomButtonStackView.addArrangedSubview($0)
        }
        
        [productImageCV, titleStackView, contourView2, uploaderStackView, contourView4, productBadgeStackView, contourView3, descriptionStackView, legalView].forEach {
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
        
        [locationLabel, dotLabel, updateAtLabel].forEach {
            titleSubInfoStackView.addArrangedSubview($0)
        }
        
        [descriptionLabel].forEach {
            descriptionStackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraint() {
        
        scrollView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        productImageCV.snp.makeConstraints {
            $0.height.equalTo(self.view.snp.width)
            $0.width.equalTo(self.view.snp.width)
        }
        
        bottomView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        buttomButtonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        contourView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
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

extension SingleProductVC {
    override func viewWillAppear(_ animated: Bool) {
        let yOffset = scrollView.contentOffset.y
        let threshold: CGFloat = 100
        var alpha: CGFloat = yOffset / threshold
        
        alpha = min(1.0, max(0.0, alpha))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        if alpha >= 1.0 {
            appearance.backgroundColor = .white
            appearance.shadowColor = .systemGray6
        } else {
            appearance.backgroundColor = UIColor(white: 1.0, alpha: alpha)
            appearance.shadowColor = .clear
        }

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension SingleProductVC: UIScrollViewDelegate {
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let threshold: CGFloat = 100
        var alpha: CGFloat = yOffset / threshold
        
        alpha = min(1.0, max(0.0, alpha))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        if alpha >= 1.0 {
            appearance.backgroundColor = .white
            appearance.shadowColor = .systemGray6
        } else {
            appearance.backgroundColor = UIColor(white: 1.0, alpha: alpha)
            appearance.shadowColor = .clear
        }

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

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
