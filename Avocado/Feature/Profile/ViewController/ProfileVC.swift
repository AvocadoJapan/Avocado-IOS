//
//  ProfileVC.swift
//  Avocado
//
//  Created by NUNU:D on 2023/08/29.
//

import UIKit
import RxDataSources

final class ProfileVC: BaseVC {

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.getCompositionalLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(
            ProfileHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderReusableView.identifier
        )
        
        $0.register(
            ProductGroupHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProductGroupHeaderReusableView.identifier
        )
        
        $0.register(
            ProductGroupFooterReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: ProductGroupFooterReusableView.identifier
        )
        
        $0.register(
            ProductCVCell.self,
            forCellWithReuseIdentifier: ProductCVCell.identifier)
    }
    
    let viewModel: ProfileVM
    
    init(viewModel: ProfileVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.actionViewDidLoad.accept(())
    }
    
    override func setProperty() {
        title = "마이페이지"
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
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<UserProfileDataSection> { dataSource, collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCVCell.identifier,
                for: indexPath
            ) as! ProductCVCell
            
            switch item {
            case .buyed(let product):
                cell.config(product: product)
                
            case .selled(let product):
                cell.config(product: product)
            }
            return cell
            
        } configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in

            switch indexPath.section {
            case 0:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ProfileHeaderReusableView.identifier,
                    for: indexPath
                ) as! ProfileHeaderReusableView
                
                let data = dataSource[indexPath.section]
                
                headerView.configure(
                    userName: data.userName ?? "",
                    creationDate: data.creationDate ?? ""
                )
                
                return headerView
                
            case 1, 2:
                if (kind == UICollectionView.elementKindSectionHeader) {
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: ProductGroupHeaderReusableView.identifier,
                        for: indexPath
                    ) as! ProductGroupHeaderReusableView
                    
                    let data = dataSource[indexPath.section]
                    
                    headerView.setProperty(title: data.productTitle ?? "")
                    
                    return headerView
                }
                else {
                    let footerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: ProductGroupFooterReusableView.identifier,
                        for: indexPath
                    ) as! ProductGroupFooterReusableView
                    
                    let data = dataSource[indexPath.section]
                    
                    footerView.configure(currentPage: self?.viewModel.input.currentPageBehavior.value ?? 0, totalPage: data.items.count/6)
                    return footerView
                }
                
            default:
                return UICollectionReusableView()
            }
        }
        
        output.successProfileEventDateSourcePublish
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension ProfileVC: CollectionViewLayoutable {
    
    private func productLayout() -> NSCollectionLayoutSection {
        // 셀 사이즈 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 셀간 간격 설정
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 0,
            trailing: 0
        )
        
        // 셀을 담을 gruop size 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(220)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        //
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 10,
            trailing: 10
        )
        
        let group1 = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        //
        group1.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 10,
            trailing: 10
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(30)
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(440)), subitems: [group, group1])
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.boundarySupplementaryItems = [header, footer]
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
            let bannerIndex = Int(max(0, round(contentOffset.x/environment.container.contentSize.width)))
            
            if (environment.container.contentSize.height < environment.container.contentSize.width) {
                self?.viewModel.input.currentPageBehavior.accept(bannerIndex)
            }
        }
        
        return section
    }
    
    private func profileLayout() -> NSCollectionLayoutSection {
        // 셀 사이즈 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 셀을 담을 gruop size 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(220)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        //
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 10,
            trailing: 10
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(270)
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
            case 0: return self?.profileLayout()
            default: return self?.productLayout()
            }
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct ProfileVCPreview: PreviewProvider {
    static var previews: some View {
        return UINavigationController(
            rootViewController: ProfileVC(
                viewModel: ProfileVM(
                    service: ProfileService()
                )
            )
        ).toPreview()
    }
}
#endif
