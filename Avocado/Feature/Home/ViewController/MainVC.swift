//
//  MainVC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources

/**
 *##화면 명: Avocado 메인화면 (배너, 카테고리 별 상품 정보를 확인가능)
 */
final class MainVC: BaseVC {
    
    private var viewModel: MainVM
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.delegate = self
    }
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private lazy var bannerCVLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    private lazy var bannerCV = UICollectionView(frame: .zero, collectionViewLayout: self.bannerCVLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .yellow
        $0.bounces = false
        $0.contentMode = .scaleAspectFill
    }
    
    
    private lazy var mainCategoryCVLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 10
        $0.sectionInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
    }
    private lazy var mainCategoryCV = UICollectionView(frame: .zero, collectionViewLayout: self.mainCategoryCVLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
    }
    
    private lazy var productGroupCVLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    private lazy var productGroupCV = UICollectionView(frame: .zero, collectionViewLayout: self.productGroupCVLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
    }
    
    private let legalView = LegalView()
    
    init(viewModel: MainVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setViewDidLoad() {
        // 초기 메인데이터 API call]
        viewModel.input.actionViewDidLoad.accept(())
    }
    
    override func setProperty() {
        view.backgroundColor = .white
        
        navigationController?.setupNavbar(with: "Avocado Beta", logoImage: UIImage(systemName: "apple.logo"))
        
        
        
        // mainCategoryCV delegate설정, 셀등록
        mainCategoryCV.delegate = self
        mainCategoryCV.dataSource = self
        mainCategoryCV.register(MainSubMenuCVCell.self, forCellWithReuseIdentifier: MainSubMenuCVCell.identifier)
        
        // bannerCV 셀등록
        bannerCV.register(BannerCVCell.self, forCellWithReuseIdentifier: BannerCVCell.identifier)
        
        // productGroupCV 셀등록 및 푸터 헤더 등록
        productGroupCV.register(ProductCVCell.self, forCellWithReuseIdentifier: ProductCVCell.identifier)
        productGroupCV.register(ProductGroupFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ProductGroupFooterReusableView.identifier)
        productGroupCV.register(ProductGroupHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProductGroupHeaderReusableView.identifier)
    }
    
    override func setLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        [bannerCV, mainCategoryCV, productGroupCV, legalView].forEach {
            stackView.addArrangedSubview($0)
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
        
        productGroupCV.snp.makeConstraints {
            $0.height.equalTo(productGroupCV.snp.width).multipliedBy(5.4)
        }
        
        bannerCV.snp.makeConstraints {
            $0.height.equalTo(300)
        }
        
        mainCategoryCV.snp.makeConstraints {
            $0.height.equalTo(75)
        }
    }
    
    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        
        productGroupCV.rx.setDelegate(self).disposed(by: disposeBag)
        bannerCV.rx.setDelegate(self).disposed(by: disposeBag)
        
        
        //        viewModel.input.actionSingleCategoryRelay.accept(string)
        
        productGroupCV
            .rx
            .modelSelected(ProductDataSection.Item.self)
            .subscribe { [weak self] item in
                self?.viewModel.input.actionSingleProductRelay.accept(item)
            }
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<ProductDataSection>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCVCell.identifier, for: indexPath) as! ProductCVCell
                
                //                cell.productSelectedRelay
                //                    .subscribe(onNext: { [weak self] in
                //                        self?.viewModel.input.actionSingleProductRelay.accept(item)
                //                    })
                //                    .disposed(by: cell.disposeBag)
                
                cell.config(product: item)
                return cell
            },
            configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
                if kind == UICollectionView.elementKindSectionHeader {
                    
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProductGroupHeaderReusableView.identifier, for: indexPath) as! ProductGroupHeaderReusableView
                    
                    let item = dataSource[indexPath.section].header
                    let id = dataSource[indexPath.section].productSectionId
                    headerView.setProperty(title: item, id: id)
                    
                    // 삭제 버튼 클릭 시
                    if let self = self {
                        headerView.moreButtonTapObservable
                            .subscribe(onNext: {
                                self.viewModel.input.actionSingleCategoryRelay.accept(id)
                            })
                            .disposed(by: headerView.disposeBag)
                    }
                    
                    return headerView
                } else if kind == UICollectionView.elementKindSectionFooter {
                    let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProductGroupFooterReusableView.identifier, for: indexPath) as! ProductGroupFooterReusableView
                    
                    let item = dataSource[indexPath.section].productSectionId
                    //                    footerView.setProperty(id: item)
                    
                    return footerView
                }
                return UICollectionReusableView()  // 기본적인 reusable view를 반환합니다.
            }
        )
        
        output.productSectionDataPublish
            .bind(to: productGroupCV.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        
        output.bannerSectionDataPublish
            .bind(to: bannerCV.rx.items(cellIdentifier: BannerCVCell.identifier, cellType: BannerCVCell.self)) { index, model, cell in
                cell.config(banner: model)
            }
            .disposed(by: disposeBag)
        
    }
}

extension MainVC {
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setTransitAlpha(yOffset: scrollView.contentOffset.y)
    }
}

extension MainVC: UIScrollViewDelegate {
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationController?.setTransitAlpha(yOffset: scrollView.contentOffset.y)

        let lowerThanTop = scrollView.contentOffset.y < 0

        if lowerThanTop {
            let offsetY = scrollView.contentOffset.y

            let minBannerHeight: CGFloat = 0
            let maxBannerHeight: CGFloat = 300

            // Calculate the new height of the banner based on the offset
            let newBannerHeight = max(minBannerHeight, maxBannerHeight - offsetY)

            // Calculate the scale based on the new height
            let scale = newBannerHeight / maxBannerHeight

            // Apply the scale transformation to the banner
            bannerCV.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCV {
            return collectionView.frame.size //bannerCV의 사이즈
        }
        else if collectionView == mainCategoryCV {
            return CGSize(width: 60, height: 75) //mainCategoryCV의 사이즈
        }
        else {
            let width = collectionView.frame.width/3 - 14
            return CGSize(width: width , height: width * 1.8) // ProductCVCell의 사이즈
        }
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    // MainSubMenuCVCell 이외 collectionView는 RX를 이용하여 처리
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainSubMenuType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubMenuCVCell.identifier, for: indexPath) as! MainSubMenuCVCell
        
        // MainSubMenuType 열거형에서 해당 indexPath에 맞는 케이스를 가져옴
        let menuType = MainSubMenuType.allCases[indexPath.item]
        
        // 셀을 해당 데이터로 구성함
        cell.configure(imageName: menuType.imageName, title: menuType.title, navigateTo: menuType.navigateTo)
        
        return cell
    }
    
    // productGroupCV의 헤더 크기 정의
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == productGroupCV {
            return CGSize(width: collectionView.frame.width, height: 60)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    // productGroupCV의 푸터 크기 정의
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == productGroupCV {
            return CGSize(width: collectionView.frame.width, height: 30)
        }
        
        return CGSize(width: 0, height: 0)
    }
}





#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct MainVCPreview: PreviewProvider {
    static var previews: some View {
        return UINavigationController(
            rootViewController: MainVC(
                viewModel: MainVM(
                    service: MainService()
                )
            )
        ).toPreview().ignoresSafeArea()
    }
}
#endif
