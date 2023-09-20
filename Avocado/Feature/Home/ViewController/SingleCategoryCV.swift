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
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
    }
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "카테고리 데모"
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 25, 
                                    weight: .heavy)
    }
    
    private lazy var productGroupCVLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = UIEdgeInsets(top: 0, 
                                       left: 10,
                                       bottom: 0,
                                       right: 10)
    }
    private lazy var productGroupCV = UICollectionView(frame: .zero, collectionViewLayout: self.productGroupCVLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
    }
    
    private let legalView = LegalView()
    
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
        
        // productGroupCV 셀등록 및 푸터 헤더 등록
        productGroupCV.register(ProductCVCell.self, forCellWithReuseIdentifier: ProductCVCell.identifier)
    }
    
    override func setLayout() {
        view.addSubview(scrollView)
        view.addSubview(titleLabel)
        scrollView.addSubview(stackView)
        
        [productGroupCV, legalView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraint() {
        // 스크롤뷰 제약 조건 설정
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        // 스택뷰 제약 조건 설정
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width) // 스택뷰의 너비는 스크롤뷰와 같게
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        productGroupCV.snp.makeConstraints {
            $0.width.equalToSuperview() // Adjust the width as needed
            $0.height.greaterThanOrEqualTo(productGroupCV.snp.width).multipliedBy(1.5)
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

