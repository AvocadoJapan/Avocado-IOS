//
//  MainVC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import RxDataSources
import RxRelay
import RxSwift
/**
 *##화면 명: Avocado 메인화면 (배너, 카테고리 별 상품 정보를 확인가능)
 */
 final class MainVC: BaseVC {
    
    private var viewModel: MainVM
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout()).then {
        $0.register(BannerCVCell.self, forCellWithReuseIdentifier: BannerCVCell.identifier)
        $0.register(MainCategoryCVCell.self, forCellWithReuseIdentifier: MainCategoryCVCell.identifier)
        $0.register(ProductCVCell.self, forCellWithReuseIdentifier: ProductCVCell.identifier)
        
        $0.register(MainHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHeaderReusableView.identifier)
        $0.register(MainFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MainFooterReusableView.identifier)
        $0.register(BannerFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: BannerFooterReusableView.identifier)
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindUI() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMainData> { dataSource, collectionView, indexPath, item in
            
            switch(item) {
            case .banner(data: let banner):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCVCell.identifier, for: indexPath) as? BannerCVCell else {
                    return UICollectionViewCell()
                }
                
                cell.onData.onNext(banner)
                return cell
                
            case .category(data: let category):
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCategoryCVCell.identifier, for: indexPath) as? MainCategoryCVCell else {
                    return UICollectionViewCell()
                }
                
                cell.onData.onNext(category)
                return cell
                
            case .product(data: let product):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCVCell.identifier, for: indexPath) as? ProductCVCell else {
                    return UICollectionViewCell()
                }
                
                cell.onData.onNext(product)
                return cell
            }
            
        } configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            
            if (kind == UICollectionView.elementKindSectionHeader) {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainHeaderReusableView.identifier, for: indexPath) as? MainHeaderReusableView
                
                let title = dataSource[indexPath.section].title
                header?.configureTitle(to: title ?? "")
                
                return header ?? MainHeaderReusableView()
            }
            else {
                switch (indexPath.section) {
                case 0:
                    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BannerFooterReusableView.identifier, for: indexPath) as? BannerFooterReusableView
                   
                    if let self = self {
                        footer?.bind(to: self.viewModel.currentBannerPage.asObservable(), totalPage: dataSource[indexPath.section].items.count)
                    }
                    
                    return footer ?? BannerFooterReusableView()
                    
                default:
                    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainFooterReusableView.identifier, for: indexPath) as? MainFooterReusableView

                    return footer ?? MainFooterReusableView()
                }
            }
        }
        
        // Collection View Bind
        viewModel.sectionData
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func setLayout() {
        view.addSubview(collectionView)
    }
    
    override func setConstraint() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
     
    //MARK: - Initalize Method
    init(vm viewModel: MainVM = MainVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
}

extension MainVC: CollectionViewLayoutable {
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            
            switch(sectionIndex) {
            case 0:
                // Banner Item 사이즈 및 셀 레이아웃 설정
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Banner Item을 넣을 Group 사이즈 및 레이아웃 설정 높이는 전체 화면의 3분의 1로 지정
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                // Banner Section 설정 스크롤 방향 설정 스크롤은 페이징 형식으로 진행 되며 횡스크롤 사용
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                
                // Banner 하단 페이지 컨트롤 추가를 위한 Footer추가 높이는 20으로 고정
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                
                section.boundarySupplementaryItems = [footer]
                section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
                    let bannerIndex = Int(max(0, round(contentOffset.x/environment.container.contentSize.width)))
                    if (environment.container.contentSize.height < environment.container.contentSize.width) {
                        self?.viewModel.currentBannerPage.accept(bannerIndex)
                    }
                    
                }
                return section
                
            case 1:
                // Category Item 사이즈 및 레이아웃 설정
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Category Item을 넣을 Group 사이즈 및 레이아웃 설정, 한 화면에 6개가 보이고 높이는 80으로 고정
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 6)
                
                // Category Section 설정 , 횡스크롤 사용 및 상하단 인셋 값 지정
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
                
            default:
                
                let itemInset:CGFloat = 5 // 인셋 값
                
                // 상품에 대한 사이즈 및 레이아웃 설정 + 아이템 별 인셋 값 추가
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                // 상품을 넣을 Group 사이즈 설정 및 레이아웃 설정, 한 화면에 3개가 보이고 높이는 전체 사이즈의 3분의 1로 설정
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
                
                // 상품 Section 설정, 인셋 값을 추가하고 스크롤은 종 스크롤을 사용
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                // 상품 하단 더보기 푸터 추가, 높이는 50으로 고정
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                
                //상품 상단 타이틀 헤더 추가, 높이는 56으로 고정
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(56))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header, footer]
                
                return section
            }
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct MainVCPreview: PreviewProvider {
    static var previews: some View {
        return UINavigationController(rootViewController: MainVC(vm: MainVM())).toPreview()
    }
}
#endif
