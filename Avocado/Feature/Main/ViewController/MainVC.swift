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
        $0.spacing = 10
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
    
    
    private lazy var mainCategoryCollectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 10
        $0.sectionInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
    }
    private lazy var mainCategoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.mainCategoryCollectionViewLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
    }
    
    private let productGroupView = ProductGroupView()
    private let productGroupView2 = ProductGroupView()
    private let productGroupView3 = ProductGroupView()
    
    private let legalView = LegalView()
    
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
        
        // 1. Create a container view
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        
        // 2. Create an image view for the logo
        let logoImageView = UIImageView().then {
            $0.image = UIImage(systemName: "apple.logo")
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .black
        }
        
        // 3. Create a label for the text
        let label = UILabel().then {
            $0.text = "Avocado Beta"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 14, weight: .bold)
        }
        
        // 4. Add the image view and label to the container view
        logoContainer.addSubview(logoImageView)
        logoContainer.addSubview(label)
        
        // 5. Set the layout
        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        
        // 6. Set the container view as the left bar button item
        let leftItem = UIBarButtonItem(customView: logoContainer)
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
        mainCategoryCollectionView.delegate = self
        mainCategoryCollectionView.dataSource = self
        mainCategoryCollectionView.register(MainSubMenuCVCell.self, forCellWithReuseIdentifier: MainSubMenuCVCell.identifier)
        
        [bannerCollectionView, mainCategoryCollectionView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [productGroupView, productGroupView2, productGroupView3, legalView ].forEach {
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
        
        mainCategoryCollectionView.snp.makeConstraints { make in
            make.height.equalTo(75)
        }
        
        legalView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return 3
        } else if collectionView == mainCategoryCollectionView {
            return MainSubMenuType.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCVCell.identifier, for: indexPath) as! BannerCVCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubMenuCVCell.identifier, for: indexPath) as! MainSubMenuCVCell
            
            // MainSubMenuType 열거형에서 해당 indexPath에 맞는 케이스를 가져옵니다.
            let menuType = MainSubMenuType.allCases[indexPath.item]
            
            // 셀을 해당 데이터로 구성합니다.
            cell.configure(imageName: menuType.imageName, title: menuType.title, navigateTo: menuType.navigateTo)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return collectionView.frame.size
        } else {
            return CGSize(width: 60, height: 75)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset > 50 {
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
