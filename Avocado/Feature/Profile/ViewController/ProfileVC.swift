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
            ProductCVCell.self,
            forCellWithReuseIdentifier: ProductCVCell.identifier)
        
        $0.register(
            OptionSilderCVCell.self,
            forCellWithReuseIdentifier: OptionSilderCVCell.identifier)
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
            switch item {
            case .slider(let title):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: OptionSilderCVCell.identifier,
                    for: indexPath
                ) as! OptionSilderCVCell
                
                cell.configure(title: title)
                return cell

            case .buyed(let product):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductCVCell.identifier,
                    for: indexPath
                ) as! ProductCVCell
                
                cell.config(product: product)
                return cell

            case .selled(let product):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductCVCell.identifier,
                    for: indexPath
                ) as! ProductCVCell
                
                cell.config(product: product)
                return cell
            }
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in

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
                    grade: data.userGrade ?? "",
                    verified: data.userVerified ?? "",
                    creationDate: data.creationDate ?? ""
                )
                
                return headerView

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
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, env in
            
            switch section {
            case 0:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0/5.0),
                    heightDimension: .absolute(35)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 10,
                    bottom: 0,
                    trailing: 10
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(35)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100)
                )
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [header]
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 10,
                    leading: 0,
                    bottom: 0,
                    trailing: 0
                )
                
                return section
                
            default:
                // 셀 사이즈 설정
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0/3.0),
                    heightDimension: .fractionalHeight(1.0)
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
                    heightDimension: .fractionalHeight(1.0/3.0)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                //
                group.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 0,
                    bottom: 10,
                    trailing: 10
                )
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
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
