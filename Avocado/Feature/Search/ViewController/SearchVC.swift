//
//  SearchVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/03.
//

import UIKit
import RxDataSources

final class SearchVC: BaseVC {
    
    private lazy var searchCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: getCompositionalLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        
        $0.register(
            SectionTitleReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionTitleReusableView.identifier
        )
        
        $0.register(
            RecentSearchCVCell.self,
            forCellWithReuseIdentifier: RecentSearchCVCell.identifier
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
    
    private let viewModel: SearchVM
    
    init(viewModel: SearchVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.actionViewWillAppearPublish.accept(())
    }
    
    override func setProperty() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    override func setLayout() {
        view.addSubview(searchCollectionView)
    }
    
    override func setConstraint() {
        searchCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        
        searchBar
            .shouldLoadResultObservable
            .bind(to: viewModel.input.searchTextPublish)
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<RecentSearchSection> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecentSearchCVCell.identifier,
                for: indexPath
            ) as! RecentSearchCVCell
            
            Logger.d("item.content \(item.content)")
            
            cell.configure(content: item.content)
            
            return cell
            
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
        
        output.recentSearchListPublish
            .bind(to: searchCollectionView
                .rx
                .items(dataSource: dataSource)
            )
            .disposed(by: disposeBag)
    }

    
}

extension SearchVC: CollectionViewLayoutable {
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, env in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 2
            )
            
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
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct SearchVCPreview: PreviewProvider {
    static var previews: some View {
        return BaseNavigationVC(
            rootViewController: SearchVC(
                viewModel:
                    SearchVM(
                        service: SearchService()
                    )
            )
        ).toPreview()
    }
}
#endif
