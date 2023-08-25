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
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "아이패드 프로 6세대 11인치 128기가 셀룰러 미개봉"
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .darkText
    }
    
    private lazy var titleSubInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
    }
    
    private lazy var locationLabel = UILabel().then {
        $0.text = "경기도 화성시 진안동"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .darkGray
    }
    
    private lazy var dotLabel = UILabel().then {
        $0.text = " ・ "
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .darkGray
    }
    
    private lazy var updateAtLabel = UILabel().then {
        $0.text = "20시간 전"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .darkGray
    }
    
    private lazy var priceLabel = UILabel().then {
        $0.text = "1,298,000원"
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .darkText
    }
    
    private lazy var uploaderView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var starRateLabel = UILabel().then {
        $0.text = "⭐️4.5"
    }
    
    private lazy var reviewLabel = UILabel().then {
        $0.text = "이 유저의 거래후기 345"
    }
    
    private lazy var uploaderNameLabel = UILabel().then {
        $0.text = "Amanda"
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 50
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
    
    private lazy var descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .darkText
        $0.text =
        """
        국회의원의 수는 법률로 정하되, 200인 이상으로 한다. 법률은 특별한 규정이 없는 한 공포한 날로부터 20일을 경과함으로써 효력을 발생한다. 대통령이 임시회의 집회를 요구할 때에는 기간과 집회요구의 이유를 명시하여야 한다.
        
        공개하지 아니한 회의내용의 공표에 관하여는 법률이 정하는 바에 의한다. 사면·감형 및 복권에 관한 사항은 법률로 정한다. 대통령은 법률에서 구체적으로 범위를 정하여 위임받은 사항과 법률을 집행하기 위하여 필요한 사항에 관하여 대통령령을 발할 수 있다.
        
        국가는 국민 모두의 생산 및 생활의 기반이 되는 국토의 효율적이고 균형있는 이용·개발과 보전을 위하여 법률이 정하는 바에 의하여 그에 관한 필요한 제한과 의무를 과할 수 있다.
        
        국회의원의 수는 법률로 정하되, 200인 이상으로 한다. 법률은 특별한 규정이 없는 한 공포한 날로부터 20일을 경과함으로써 효력을 발생한다. 대통령이 임시회의 집회를 요구할 때에는 기간과 집회요구의 이유를 명시하여야 한다.
        
        공개하지 아니한 회의내용의 공표에 관하여는 법률이 정하는 바에 의한다. 사면·감형 및 복권에 관한 사항은 법률로 정한다. 대통령은 법률에서 구체적으로 범위를 정하여 위임받은 사항과 법률을 집행하기 위하여 필요한 사항에 관하여 대통령령을 발할 수 있다.
        
        국가는 국민 모두의 생산 및 생활의 기반이 되는 국토의 효율적이고 균형있는 이용·개발과 보전을 위하여 법률이 정하는 바에 의하여 그에 관한 필요한 제한과 의무를 과할 수 있다.
        """
    }
    
    private let legalView = LegalView()
    
    init(viewModel: SingleProductVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
//        self.navigationController?.isNavigationBarHidden = false
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
        
        [productImageCV, titleStackView, descriptionStackView, legalView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [titleLabel, titleSubInfoStackView, priceLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [locationLabel, dotLabel, updateAtLabel].forEach {
            titleSubInfoStackView.addArrangedSubview($0)
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
            $0.leading.trailing.top.bottom.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
    
        productImageCV.snp.makeConstraints {
            $0.size.equalTo(self.view.snp.width)
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

extension SingleProductVC: UIScrollViewDelegate {
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset > 50 {
            navigationController?.setNavigationBarHidden(false, animated: true) // 네비게이션바 표시
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true) // 네비게이션바 숨기기
        }
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
