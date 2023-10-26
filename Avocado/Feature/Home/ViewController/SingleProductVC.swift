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
import RxDataSources

/**
 *## description: 컴포지셔널로 구성된 단일 상품 상세페이지
 */
final class SingleProductVC: BaseVC {
    
    private var viewModel: SingleProductVM
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.getCompositionalLayout()
    ).then {
        $0.backgroundColor = .white
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
        
        // 섹션별 해더
        $0.register(
            SectionTitleReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionTitleReusableView.identifier
        )
        
        // 사진뷰 셀 section 0
        $0.register(
            ProductImageCVCell.self,
            forCellWithReuseIdentifier: ProductImageCVCell.identifier
        )
        
        // 단일상품 제목 section 1
        $0.register(
            ProductTitleCVCell.self,
            forCellWithReuseIdentifier: ProductTitleCVCell.identifier
        )
        
        // 업로더 프로필 셀 section 2
        $0.register(
            SimpleProfileCVCell.self,
            forCellWithReuseIdentifier: SimpleProfileCVCell.identifier
        )
        
        // 상품 베지 section 3
        $0.register(
            DescriptionBadgeCVCell.self,
            forCellWithReuseIdentifier: DescriptionBadgeCVCell.identifier
        )
        
        // 상품 설명 section 4
        $0.register(
            ProductDescriptionCVCell.self,
            forCellWithReuseIdentifier: ProductDescriptionCVCell.identifier
        )
        
        // 관련 상품 셀 section 5
        $0.register(
            ProductCVCell.self,
            forCellWithReuseIdentifier: ProductCVCell.identifier
        )
        
        // 가장 마지막섹션 법률 정보 푸터 section 5 footer
        $0.register(
            LegalFooterReuseableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LegalFooterReuseableView.identifier
        )
    }
    
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
        
        // 탭바 숨기기
        hidesBottomBarWhenPushed = true
    }
    
    override func setProperty() {
        view.backgroundColor = .white
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.backgroundColor = .white
    }
    
    override func setLayout() {
        view.addSubview(collectionView)
    }
    
    override func setConstraint() {
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SingleProductDataSection> { dataSource, collectionView, indexPath, item in
                
                switch item {
                case .image(let data):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCVCell.identifier, for: indexPath) as! ProductImageCVCell
                  
                    return cell
                case .title(let data):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductTitleCVCell.identifier, for: indexPath) as! ProductTitleCVCell
                    
                    return cell
                case .profile(let data):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimpleProfileCVCell.identifier, for: indexPath) as! SimpleProfileCVCell
                    
                    return cell
                case .badge(let data):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionBadgeCVCell.identifier, for: indexPath) as! DescriptionBadgeCVCell
               
                    return cell
                case .description(let data):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDescriptionCVCell.identifier, for: indexPath) as! ProductDescriptionCVCell
                    
                    return cell
                case .recomendation(let data):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCVCell.identifier, for: indexPath) as! ProductCVCell
                    
                    return cell
                }
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            
            if kind == UICollectionView.elementKindSectionFooter {
                let FooterView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: LegalFooterReuseableView.identifier,
                    for: indexPath
                ) as! LegalFooterReuseableView
                
                return FooterView
            } else {
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionTitleReusableView.identifier,
                    for: indexPath
                ) as! SectionTitleReusableView
                
                headerView.configure(title: "판매자 프로필")
                
                return headerView
            }
        }
        
        output.dataSourcePublish
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    
}

extension SingleProductVC: CollectionViewLayoutable {
    
    private func badgeLayout() -> NSCollectionLayoutSection {
        // 아이템 사이즈 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 그룹사이즈 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        
        // 헤더 설정
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        
        return section
    }
    
    private func topPhotoLayout() -> NSCollectionLayoutSection {
        // 아이템 사이즈 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // 그룹사이즈 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func gridLayout() -> NSCollectionLayoutSection {
        // 아이템 사이즈 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3.0),
            heightDimension: .absolute(200)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 셀간 간격 설정
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5
        )

        // 그룹사이즈 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let firstRowHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 6)
        
        firstRowHorizontalGroup.contentInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 15,
            bottom: 20,
            trailing: 15
        )
        
        let secondRowHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])
        //        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 6)
                
        secondRowHorizontalGroup.contentInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 15,
            bottom: 20,
            trailing: 15
        )
        
        let nestedVerticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5)),
            subitems: [firstRowHorizontalGroup, secondRowHorizontalGroup])
        
        // 섹션 설정
        let section = NSCollectionLayoutSection(group: nestedVerticalGroup)
        
        section.orthogonalScrollingBehavior = .groupPaging

        // 헤더 설정
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(30)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        // 푸터 설정
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(250)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        section.boundarySupplementaryItems = [header, footer]

        return section
    }


    
    private func titleLayout() -> NSCollectionLayoutSection {
        // 아이템 사이즈 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // 그룹사이즈 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func profileLayout() -> NSCollectionLayoutSection {
        // 아이템 사이즈 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // 그룹사이즈 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(70)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        // 헤더 설정
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(30)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func descriptionLayout() -> NSCollectionLayoutSection {
        // 아이템 사이즈 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // 그룹사이즈 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        // 헤더 설정
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(30)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func deafaultLayout() -> NSCollectionLayoutSection {
        // 아이템 사이즈 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0),
            heightDimension: .fractionalWidth(0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // 그룹사이즈 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0),
            heightDimension: .fractionalWidth(0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, configuration in
            
            Logger.d(section)
            
            switch section {
            case 0: return self?.topPhotoLayout() // 사진
            case 1: return self?.titleLayout() // 타이틀
            case 2: return self?.profileLayout() // 업로더
            case 3: return self?.badgeLayout() // 배지
            case 4: return self?.descriptionLayout() // 설명
            case 5: return self?.gridLayout() // 작은 상품
            default: return self?.deafaultLayout()
            }
        }
    }
}

//extension SingleProductVC {
//    override func viewWillAppear(_ animated: Bool) {
//        let photoWidth = self.view.frame.width
//        let yOffset = scrollView.contentOffset.y - photoWidth + 200
//
//        navigationController?.setTransitAlpha(yOffset: yOffset)
//    }
//}

//extension SingleProductVC: UIScrollViewDelegate {
//    // MARK: - UIScrollViewDelegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let photoWidth = self.view.frame.width
//        let yOffset = scrollView.contentOffset.y - photoWidth + 200
//
//        navigationController?.setTransitAlpha(yOffset: yOffset)
//    }
//}

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
