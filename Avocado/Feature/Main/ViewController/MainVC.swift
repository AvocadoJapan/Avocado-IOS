//
//  MainVC.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

/**
 *##화면 명: Avocado 메인화면 (배너, 카테고리 별 상품 정보를 확인가능)
 */
final class MainVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    private var viewModel: MainVM
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.delegate = self
    }
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    private lazy var bannerCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    private lazy var bannerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.bannerCollectionViewLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
    }
    
    private lazy var MainCategoryCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 10
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    private lazy var MainCategoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.MainCategoryCollectionViewLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
    }
    
    private let productGroupView = ProductGroupView()
    private let productGroupView2 = ProductGroupView()
    private let productGroupView3 = ProductGroupView()
    
    init(viewModel: MainVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bindUI() {
        //        viewModel.banners
        //            .bind(to: bannerCollectionView.rx.items(cellIdentifier: BannerCVCell.identifier, cellType: BannerCVCell.self)) { row, banner, cell in
        //                cell.onData.onNext(banner)
        //            }
        //            .disposed(by: disposeBag)
    }
    
    override func setProperty() {
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let logo = UIImageView().then {
            $0.image = UIImage(named: "logo_avocado")
            $0.contentMode = .scaleAspectFit
        }
        let leftItem = UIBarButtonItem(customView: logo)
        navigationItem.leftBarButtonItem = leftItem
    }
    
    override func setLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // Configure Banner Collection View
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(BannerCVCell.self, forCellWithReuseIdentifier: BannerCVCell.identifier)
        
        // Configure Main Category Collection View
        MainCategoryCollectionView.delegate = self
        MainCategoryCollectionView.dataSource = self
        MainCategoryCollectionView.register(MainCategoryCVCell.self, forCellWithReuseIdentifier: MainCategoryCVCell.identifier)
        
        [bannerCollectionView, MainCategoryCollectionView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [productGroupView, productGroupView2, productGroupView3 ].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraint() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        [productGroupView, productGroupView2, productGroupView3].forEach {
            $0.snp.makeConstraints { make in
                //                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(540)
            }
        }
        
        bannerCollectionView.snp.makeConstraints { make in
            //            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300) // Or whatever height you want for the banner
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCVCell.identifier, for: indexPath) as! BannerCVCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset > 100 {
            navigationController?.setNavigationBarHidden(false, animated: true) // 네비게이션바 표시
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true) // 네비게이션바 숨기기
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct MainVCPreview: PreviewProvider {
    static var previews: some View {
        return UINavigationController(
            rootViewController: MainVC(
                viewModel: MainVM(
                    service: MainService(),
                    user: User(
                        userId: "demo",
                        nickName: "demo",
                        updateAt: 1234567,
                        createdAt: 1234567,
                        accounts: Accounts(cognito: "demo"),
                        avatar: Avatar(
                            id: "1234",
                            changedAt: 1234567
                        )
                    )
                )
            )
        ).toPreview()
    }
}
#endif
