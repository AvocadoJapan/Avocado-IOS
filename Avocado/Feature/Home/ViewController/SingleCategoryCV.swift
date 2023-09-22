//
//  SingleCategoryVC.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/13.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources

final class SingleCategoryVC: BaseVC {
    
    private var viewModel: SingleCategoryVM
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "카테고리 데모"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, 
                                    weight: .heavy)
        $0.textAlignment = .natural
    }
    
    private lazy var productGroupCVLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = UIEdgeInsets(top: 10,
                                       left: 10,
                                       bottom: 10,
                                       right: 10)
    }
    private lazy var productGroupCV = UICollectionView(frame: .zero, collectionViewLayout: self.productGroupCVLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
    }
    
    init(viewModel: SingleCategoryVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setViewDidLoad() {
        // 초기 메인데이터 API call]
        viewModel.input.actionViewDidLoad.accept(())
    }
    
    override func setProperty() {
        view.backgroundColor = .white
        
        // productGroupCV 셀등록
        productGroupCV.register(ProductCVCell.self, forCellWithReuseIdentifier: ProductCVCell.identifier)
        productGroupCV.register(LegalFooterReuseableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LegalFooterReuseableView.identifier)
    }
    
    override func setLayout() {
        view.addSubview(titleLabel)
        view.addSubview(productGroupCV)
    }
    
    override func setConstraint() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        productGroupCV.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
         }
    }
    
    override func bindUI() {
        let output = viewModel.transform(input: viewModel.input)
        
        productGroupCV.rx.setDelegate(self).disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<ProductDataSection>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCVCell.identifier, for: indexPath) as! ProductCVCell
                
                cell.productSelectedRelay
                    .subscribe(onNext: { [weak self] in
                        self?.viewModel.input.actionSingleProductRelay.accept(item)
                    })
                    .disposed(by: cell.disposeBag)

                cell.config(product: item)
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                
                
                    let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LegalFooterReuseableView.identifier, for: indexPath) as! LegalFooterReuseableView
                    
                    return footerView
            }
        )
        
        output.singleCategoryProductListPublish
            .bind(to: productGroupCV.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.singleCategoryProductListPublish
            .map { ProductDataSectionArr in
                return ProductDataSectionArr.first?.header ?? ""
            }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
}

extension SingleCategoryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let width = collectionView.frame.width/3 - 14
            return CGSize(width: width , height: width * 1.6) // ProductCVCell의 사이즈
    }
    
    // productGroupCV의 푸터 크기 정의
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == productGroupCV {
            return CGSize(width: collectionView.frame.width, height: 200)
        }
        
        return CGSize(width: 0, height: 0)
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
import SPIndicator

struct SingleCategoryVCPreview: PreviewProvider {
    static var previews: some View {
        
        let viewModel = SingleCategoryVM(service: MainService(), id: "")
        return UINavigationController(rootViewController: SingleCategoryVC(viewModel: viewModel)).toPreview()
    }
}
#endif

