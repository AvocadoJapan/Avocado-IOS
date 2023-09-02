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
        title = "프로필"
        navigationController?.navigationBar.prefersLargeTitles = true
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
            
            if (kind == UICollectionView.elementKindSectionHeader) {
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ProfileHeaderReusableView.identifier,
                    for: indexPath
                ) as! ProfileHeaderReusableView
                
                let data = dataSource[indexPath.section]
                
                // 2번째 섹션일 경우 프로필 화면을 보여주지 않도록 모드 변경
                if indexPath.section == 1 { headerView.changedMode(isProfile: false)}
                
                headerView.configure(
                    userName: data.userName ?? "",
                    creationDate: data.creationDate ?? "",
                    productTitle: data.productTitle ?? ""
                )
                
                return headerView
            }
            else {
                let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ProductGroupFooterReusableView.identifier,
                    for: indexPath
                ) as! ProductGroupFooterReusableView
                
                let data = dataSource[indexPath.section]
                
                footerView.configure(
                    data:self?.viewModel.input.currentPageBehavior.asObservable() ?? .just(0),
                    totalPage: data.items.count/6
                )
                
                return footerView
            }
        }
        
        collectionView
            .rx
            .modelSelected(UserProfileDataSection.Item.self)
            .asDriver()
            .drive(onNext: { [weak self] item in
                switch item {
                case .buyed(let product):
                    self?.viewModel.steps.accept(ProfileStep.productDetailIsRequired(product: product))
                    
                case .selled(let product):
                    self?.viewModel.steps.accept(ProfileStep.productDetailIsRequired(product: product))
                }
            })
            .disposed(by: disposeBag)
        
        output.successProfileEventDateSourcePublish
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension ProfileVC: CollectionViewLayoutable {
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, env in
            // 셀 사이즈 설정
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // 셀간 간격 설정
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 10,
                bottom: 0,
                trailing: 0
            )
            
            // 셀을 담을 gruop size 설정
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(220)
            )
            
            let firstGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 3
            )
            
            let secondGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 3
            )
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(190)
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
            
            let containerSize =  NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(440)
            )
            
            let containerGroup = NSCollectionLayoutGroup.vertical(
                layoutSize:containerSize,
                subitems: [firstGroup, secondGroup]
            )
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.boundarySupplementaryItems = [header, footer]
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 10
            )
            
            section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
                let bannerIndex = Int(max(0, round(contentOffset.x/environment.container.contentSize.width)))
                
                // 가로 스크롤일 경우에만 뷰모델에 현재 페이지 정보 값 전달
                if (environment.container.contentSize.height == containerSize.heightDimension.dimension) {
                    self?.viewModel.input.currentPageBehavior.accept(bannerIndex)
                }
            }
            
            return section
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
