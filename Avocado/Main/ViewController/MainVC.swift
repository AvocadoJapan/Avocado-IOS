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
        $0.register(MainHeaderRV.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHeaderRV.identifier)
        $0.register(ProductCC.self, forCellWithReuseIdentifier: ProductCC.identifier)
    }
    private let disposeBag = DisposeBag()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindUI() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<MainSectionM> { dataSource, collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCC.identifier, for: indexPath) as? ProductCC else {
             return UICollectionViewCell()
            }
            cell.configureCell()
            
            
            return cell
        } configureSupplementaryView: { dataSource, collectionview, title, indexPath in
            switch (indexPath.section) {
            case 0:
                guard let header = collectionview.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHeaderRV.identifier, for: indexPath) as? MainHeaderRV else {
                    return UICollectionReusableView()
                }
                
                return header
            case 1:
                return UICollectionReusableView()
                
            case 2:
                return UICollectionReusableView()
                
            default:
                return UICollectionReusableView()
            }
        }
        
        viewModel.mainDataOb.accept(
            MainData(bannerList: [], recommandProductList: [], friendProductList: [], fruitProductList: [])
        )
        
        viewModel.mainDataOb.bind(to: collectionView.rx.items(dataSource: dataSource))
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
    
    init(vm viewModel: MainVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        viewModel = MainVM()
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
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.pinToVisibleBounds = true
                
                section.boundarySupplementaryItems = [header, footer]
                return section
            case 1:
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(56))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header, footer]
                return section
                
            case 2:
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
