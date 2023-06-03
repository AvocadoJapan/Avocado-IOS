//
//  MainVC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import RxDataSources

final class MainVC: BaseVC {
    
    private var viewModel: MainVM
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout()).then {
        $0.register(BannerCC.self, forCellWithReuseIdentifier: BannerCC.identifier)
        $0.register(MainCategoryCC.self, forCellWithReuseIdentifier: MainCategoryCC.identifier)
        $0.register(ProductCC.self, forCellWithReuseIdentifier: ProductCC.identifier)
        
        $0.register(MainHeaderRV.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHeaderRV.identifier)
        $0.register(MainFooterRV.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MainFooterRV.identifier)
    }
    private let disposeBag = DisposeBag()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindUI() {
        var dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMainData> { dataSource, collectionView, indexPath, item in
            
            switch(item) {
            case .banner(data: let banner):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCC.identifier, for: indexPath) as? BannerCC else {
                    return UICollectionViewCell()
                }
                
                cell.configureCell()
                
                return cell
                
            case .category(data: let category):
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCategoryCC.identifier, for: indexPath) as? MainCategoryCC else {
                    return UICollectionViewCell()
                }
                
                return cell
                
            case .product(data: let product):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCC.identifier, for: indexPath) as? ProductCC else {
                    return UICollectionViewCell()
                }
                
                cell.configureCell()
                return cell
            }
            
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            
            
            if (kind == UICollectionView.elementKindSectionHeader) {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainHeaderRV.identifier, for: indexPath) as? MainHeaderRV
                
                return header ?? MainHeaderRV()
            }
            else {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainFooterRV.identifier, for: indexPath) as? MainFooterRV
                
                return footer ?? MainFooterRV()
            }
        }
        
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
            let itemFractionalWidthFraction = 1.0 / 3.0
            let itemInset:CGFloat = 5
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalWidthFraction), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
            
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
            
            switch(sectionIndex) {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                
                section.boundarySupplementaryItems = [footer]
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(60), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                section.boundarySupplementaryItems = [footer]
                return section
            case 2:
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(56))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header, footer]
                return section
                
            case 3:
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(56))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header, footer]
                return section
                
            case 4:
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(56))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header, footer]
                return section
                
            default:
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
