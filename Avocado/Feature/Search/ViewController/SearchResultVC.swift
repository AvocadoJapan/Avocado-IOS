//
//  SearchResultVC.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/14.
//

import UIKit
import RxDataSources

final class SearchResultVC: BaseVC {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout()).then {
        $0.showsVerticalScrollIndicator = false
        
        $0.register(
            CatecogyCVCell.self,
            forCellWithReuseIdentifier: CatecogyCVCell.identifier
        )
        
        $0.register(
            SearchResultCVCell.self,
            forCellWithReuseIdentifier: SearchResultCVCell.identifier
        )
        
        $0.register(
            SectionTitleReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionTitleReusableView.identifier
        )
    }
    
    private lazy var searchBar = RxSearchBar(
        frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width - 20,
            height: 0
        )
    ).then {
        $0.placeholder = "검색어를 입력해주세요"
    }
    
    let viewModel: SearchResultVM
    
    init(viewModel: SearchResultVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setProperty() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    override func setLayout() {
        view.addSubview(collectionView)
    }
    
    override func setConstraint() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        
        viewModel
            .input
            .userSearchKewordPublish
            .bind(to: searchBar.rx.text)
            .disposed(by: disposeBag)
        
        searchBar
            .shouldLoadResultObservable
            .bind(to: viewModel.input.userSearchKewordPublish)
            .disposed(by: disposeBag)
        
        let dataSources = RxCollectionViewSectionedReloadDataSource<SearchResultSection> { dataSource, collectionview, indexPath, item in
            switch item {
            case .category(let category):
                let cell = collectionview.dequeueReusableCell(
                    withReuseIdentifier: CatecogyCVCell.identifier,
                    for: indexPath
                ) as! CatecogyCVCell
                
                cell.configure(title: category)
                
                return cell
                
            case .product(let product):
                let cell = collectionview.dequeueReusableCell(
                    withReuseIdentifier: SearchResultCVCell.identifier,
                    for: indexPath
                ) as! SearchResultCVCell
                
                cell.configure(
                    title: product.name,
                    category: "ipad",
                    location: product.location,
                    price: 100000
                )
                
                return cell
            }
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionTitleReusableView.identifier,
                for: indexPath
            ) as! SectionTitleReusableView
            
            let data = dataSource[indexPath.section]
            
            headerView.configure(title: data.header ?? "")
            
            return headerView
        }
        
        output.successSearchResultListPublish
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView
                .rx
                .items(dataSource: dataSources)
            )
            .disposed(by: disposeBag)
    }
}

extension SearchResultVC: CollectionViewLayoutable {
    private func categoryLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .absolute(40)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .absolute(40)
        )
        
        let group = NSCollectionLayoutGroup
            .horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
        
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 20,
            bottom: 10,
            trailing: 0
        )
        return section
    }
    
    private func searchProductLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(110)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, env in
            switch section {
            case 0:
                return self?.categoryLayout()
                
            default:
                return self?.searchProductLayout()
                
            }
        }
    }
}
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct SearchResultVCPreview: PreviewProvider {
    static var previews: some View {
        return SearchResultVC(
            viewModel: SearchResultVM(
                service: SearchService(),
                keyword: ""
            )
        )
        .toPreview()
    }
}
#endif
