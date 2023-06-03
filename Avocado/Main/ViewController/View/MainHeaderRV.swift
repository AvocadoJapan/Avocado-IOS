//
//  MainHeaderRV.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import RxSwift

final class MainHeaderRV: UICollectionReusableView {
    static var identifier = "MainHeaderRV"
    
    private lazy var adBannerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout()).then {
        $0.register(MainCategoryCC.self, forCellWithReuseIdentifier: MainCategoryCC.identifier)
    }
    
    public var onChanged: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(adBannerCollectionView)
        
        adBannerCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        Observable.just(["qwe","qwe","qwe","qwe","qwe"])
            .bind(to: adBannerCollectionView.rx.items(cellIdentifier: MainCategoryCC.identifier, cellType: MainCategoryCC.self)) { index, item, cell in
                cell.configureCell()
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainHeaderRV: CollectionViewLayoutable {
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in

            switch(sectionIndex) {
            case 0:
                let itemFractionalWidthFraction = 1.0 / 3.0
                let itemInset:CGFloat = 5
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalWidthFraction), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
                /* 레이아웃에 어떤아이템이 들어가고 화면에 몇개의 아이템이 보일건지 설정해줌
                 > groupSize의 값을 받고, item이 한화면에 2개씩 보여지는 그룹을 생성 */
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                section.orthogonalScrollingBehavior = .continuous
                
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                
                section.boundarySupplementaryItems = [footer]
                
                return section
            case 1:
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
            default:
                fatalError()
            }
        }
    }
    
    
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
struct MainHeaderRVPreview:PreviewProvider {
    static var previews: some View {
        return MainHeaderRV().toPreview().previewLayout(.fixed(width: 414, height: 300))
    }
}
#endif
