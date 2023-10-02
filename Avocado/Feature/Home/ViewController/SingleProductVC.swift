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

final class SingleProductVC: BaseVC {
    
    private var viewModel: SingleProductVM
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.delegate = self
    }
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 22
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
    
    private lazy var titleLabel = UILabel(labelAprearance: .header).then {
        $0.text = "아이패드 프로 12.9 5세대"
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 2
    }
    
    private lazy var titleSubInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
    }
    
    private lazy var locationLabel = UILabel(labelAprearance: .subtitle).then {
        $0.text = "서울특별시 성북구 안암동"
        $0.numberOfLines = 1
    }
    
    private lazy var dotLabel = UILabel(labelAprearance: .subtitle).then {
        $0.text = " ・ "
        $0.numberOfLines = 1
    }
    
    private lazy var updateAtLabel = UILabel(labelAprearance: .subtitle).then {
        $0.text = "20시간 전"
        $0.numberOfLines = 1
    }
    
    private lazy var priceLabel = UILabel(labelAprearance: .header).then {
        $0.text = "1,298,000원"
        $0.numberOfLines = 1
    }
    
    private lazy var uploaderProfileView = UserProfileView()
    
    // 하단 고정뷰 (좋아요 채팅, 결제 등)
    private lazy var bottomView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var contourView = ContourView()
    private lazy var contourView2 = ContourView(inset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    private lazy var contourView3 = ContourView(inset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    private lazy var contourView4 = ContourView(inset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    
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
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var productBadgeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 15
        $0.distribution = .fillEqually
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var productBadgeDemo = ProductBadgeView(type: .avocadoPay)
    private lazy var productBadgeDemo2 = ProductBadgeView(type: .business)
    private lazy var productBadgeDemo3 = ProductBadgeView(type: .fastShipping)
    private lazy var productBadgeDemo4 = ProductBadgeView(type: .freeShipping)
    private lazy var productBadgeDemo5 = ProductBadgeView(type: .handmade)
    private lazy var productBadgeDemo6 = ProductBadgeView(type: .premiumSeller)
    private lazy var productBadgeDemo7 = ProductBadgeView(type: .refundable)
    private lazy var productBadgeDemo8 = ProductBadgeView(type: .unused)
    private lazy var productBadgeDemo9 = ProductBadgeView(type: .verified)
    
    private lazy var descriptionLabel = UILabel(labelAprearance: .normal).then {
        $0.numberOfLines = 0
        $0.text =
        """
        2023년 4월 말에 구입
        
        - 아이패드 프로 5세대 M1 128기가 스페이스그레이입니다.
        - 외관 S급입니다. 기능 이상 없습니다.
        - 배터리효율 85퍼센트입니다.
        - 구성은 풀박스에 펜슬수납 가능 케이스 함께 드립니다.
        
        오늘(27일) 구입한 아이패드 미니6 와이파이버전 64기가 모델을 팝니다..
        오늘 쿠팡에서 새걸로 구입한 겁니다..

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
        
        // 탭바 숨기기
        hidesBottomBarWhenPushed = true
    }
    
    override func bindUI() {
        favButton
            .rx
            .tap
            .subscribe { _ in
                SPIndicator.present(title: "시스템 에러", message: "지원하지 않는 기능", preset: .error, haptic: .error)
            }
            .disposed(by: disposeBag)
        
        dmButton
            .rx
            .tap
            .subscribe { _ in
                SPIndicator.present(title: "시스템 에러", message: "지원하지 않는 기능", preset: .error, haptic: .error)
            }
            .disposed(by: disposeBag)
        
        purchaseButton
            .rx
            .tap
            .subscribe { _ in
                SPIndicator.present(title: "시스템 에러", message: "지원하지 않는 기능", preset: .error, haptic: .error)
            }
            .disposed(by: disposeBag)
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
        
        [productImageCV, titleStackView, contourView2, uploaderProfileView, contourView4, productBadgeStackView, contourView3, descriptionStackView, legalView].forEach {
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
        
        locationLabel.setContentHuggingPriority(UILayoutPriority(751), for: .horizontal)
        dotLabel.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        updateAtLabel.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        
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
            $0.height.equalTo(70)
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
        
        uploaderProfileView.snp.makeConstraints {
            $0.height.equalTo(50)
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
        let photoWidth = self.view.frame.width
        let yOffset = scrollView.contentOffset.y - photoWidth + 200
        
        navigationController?.setTransitAlpha(yOffset: yOffset)
    }
}

extension SingleProductVC: UIScrollViewDelegate {
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let photoWidth = self.view.frame.width
        let yOffset = scrollView.contentOffset.y - photoWidth + 200
        
        navigationController?.setTransitAlpha(yOffset: yOffset)
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
import SPIndicator

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
