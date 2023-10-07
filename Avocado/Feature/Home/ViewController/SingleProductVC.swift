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
        
        // 가로스크롤 가능 사진뷰
        $0.register(
            PhotoScrollHeaderRV.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PhotoScrollHeaderRV.identifier
        )
        
        // 각 그룹별 헤더
        $0.register(
            CompositionalHeaderRV.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CompositionalHeaderRV.identifier
        )
        
        // 단일상품 제목셀
        $0.register(
            ProductTitleCVCell.self,
            forCellWithReuseIdentifier: ProductTitleCVCell.identifier
        )
        
        // 업로더 프로필
        $0.register(
            SimpleProfileCVCell.self,
            forCellWithReuseIdentifier: SimpleProfileCVCell.identifier
        )
        
        // 상품 베지 셀
        $0.register(
            DescriptionBadgeCVCell.self,
            forCellWithReuseIdentifier: DescriptionBadgeCVCell.identifier
        )
        
        // 상품 설명 셀
        $0.register(
            ProductDescriptionCVCell.self,
            forCellWithReuseIdentifier: ProductDescriptionCVCell.identifier
        )
        
        // 법률정보 푸터
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
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
        }
    }
    
    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        
    }
    
    
}

extension SingleProductVC: CollectionViewLayoutable {
    
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

        // 그룹을 섹션에 넣기
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] section, configuration in
            
            switch section {
            case 0: return self?.topPhotoLayout()
            default: return nil
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
