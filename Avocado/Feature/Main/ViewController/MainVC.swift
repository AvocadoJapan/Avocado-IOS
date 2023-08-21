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
final class MainVC: BaseVC, UICollectionViewDelegate{
    
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
    
    private lazy var bannerCVLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    private lazy var bannerCV = UICollectionView(frame: .zero, collectionViewLayout: self.bannerCVLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
    }
    
    
    private lazy var mainCategoryCVLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 10
        $0.sectionInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
    }
    private lazy var mainCategoryCV = UICollectionView(frame: .zero, collectionViewLayout: self.mainCategoryCVLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
    }
    
    private lazy var productGroupCVLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 10
        $0.sectionInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
    }
    private lazy var productGroupCV = UICollectionView(frame: .zero, collectionViewLayout: self.productGroupCVLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
    }
    
    private let legalView = LegalView()
    
    init(viewModel: MainVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        // 초기 메인데이터 API call
        viewModel.input.actionViewDidLoad.accept(())
    }
    
    override func setProperty() {
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        navigationController?.setupNavbar(with: "Avocado Beta", logoImage: UIImage(systemName: "apple.logo"))
    }
    
    override func setLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // Configure Banner Collection View
        bannerCV.delegate = self
        bannerCV.dataSource = self
        bannerCV.register(BannerCVCell.self, forCellWithReuseIdentifier: BannerCVCell.identifier)
        
        // Configure Main Category Collection View
        mainCategoryCV.delegate = self
        mainCategoryCV.dataSource = self
        mainCategoryCV.register(MainSubMenuCVCell.self, forCellWithReuseIdentifier: MainSubMenuCVCell.identifier)
        
        // Configure Product Group  Collection View
        productGroupCV.delegate = self
        productGroupCV.dataSource = self
        productGroupCV.register(ProductGroupCVCell.self, forCellWithReuseIdentifier: ProductGroupCVCell.identifier)
        
        
        [bannerCV, mainCategoryCV, productGroupCV, legalView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraint() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        productGroupCV.snp.makeConstraints {
             $0.height.equalTo(540 * 3 + 20)
         }
        
        bannerCV.snp.makeConstraints {
            $0.height.equalTo(300)
        }
        
        mainCategoryCV.snp.makeConstraints {
            $0.height.equalTo(75)
        }
        
        legalView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
}

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCV {
            return 3
        } else if collectionView == mainCategoryCV {
            return MainSubMenuType.count
        } else if collectionView == productGroupCV {
            return 3
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCVCell.identifier, for: indexPath) as! BannerCVCell
            
            return cell
        } else if collectionView == mainCategoryCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSubMenuCVCell.identifier, for: indexPath) as! MainSubMenuCVCell
            
            // MainSubMenuType 열거형에서 해당 indexPath에 맞는 케이스를 가져옵니다.
            let menuType = MainSubMenuType.allCases[indexPath.item]
            
            // 셀을 해당 데이터로 구성합니다.
            cell.configure(imageName: menuType.imageName, title: menuType.title, navigateTo: menuType.navigateTo)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductGroupCVCell.identifier, for: indexPath) as! ProductGroupCVCell
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCV {
            return collectionView.frame.size
        } else if collectionView == mainCategoryCV {
            return CGSize(width: 60, height: 75)
        } else {
            return  CGSize(width: collectionView.frame.width, height: 540)
        }
    }
}

extension MainVC: UIScrollViewDelegate {
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
