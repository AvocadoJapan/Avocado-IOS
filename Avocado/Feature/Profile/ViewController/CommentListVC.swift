//
//  CommentListVC.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/18.
//

import UIKit
import RxDataSources

final class CommentListVC: BaseVC {
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: getCompositionalLayout()
    ).then {
        $0.backgroundColor = .white
        
        $0.register(
            CommentListCVCell.self,
            forCellWithReuseIdentifier: CommentListCVCell.identifier
        )
        
        $0.register(
            SectionTitleReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionTitleReusableView.identifier
        )
    }
    
    let viewModel: CommentListVM
    
    init(viewModel: CommentListVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        /*
        FIXME: 추후 페이징 기능 도입 시 적용 예정
        collectionView
            .rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] (cell, indexPath) in
                Logger.d(output.successCommentListBehavior.value.count - 1)
                Logger.d(indexPath.row)
                if indexPath.row == output.successCommentListBehavior.value.count - 1 {
                    self?.viewModel.input.currentPageBehavior.accept((self?.viewModel.input.currentPageBehavior.value ?? 0) + 1)
                }
            })
            .disposed(by: disposeBag)
         */
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<CommentListDataSection>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CommentListCVCell.identifier,
                    for: indexPath
                ) as! CommentListCVCell
                
                cell.configure(
                    comment: item.comment,
                    name: item.name,
                    creationDate: item.creationDate,
                    productTitle: item.product.name
                )
                
                cell.productDetailTapObservable
                    .subscribe(onNext: {
                        self?.viewModel.steps.accept(ProfileStep.productDetailIsRequired(product: item.product))
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            }) { dataSource, collectionView, kind, indexPath in
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionTitleReusableView.identifier,
                    for: indexPath
                ) as! SectionTitleReusableView
                
                let data = dataSource[indexPath.section]
                
                header.configure(title: data.header ?? "")
                
                return header
            }
        
        output.successCommentListBehavior
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}

extension CommentListVC: CollectionViewLayoutable {
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { section, env in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(180)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(180)
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            )
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            section.boundarySupplementaryItems = [header]
            // 그룹 별 인셋 설정
            section.interGroupSpacing = 20
            
            return section
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct CommentListVCPreview: PreviewProvider {
    static var previews: some View {
        return CommentListVC(
            viewModel: CommentListVM(
                service: ProfileService(
                    isStub: true,
                    sampleStatusCode: 200
                )
            )
        )
        .toPreview()
    }
}
#endif
