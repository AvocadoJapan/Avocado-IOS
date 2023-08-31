//
//  BannerFooterRV.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
import RxSwift
/**
 *## 화면명: 메인화면 배너 하단에 들어갈 푸터 (UIPageControl)
 */
final class BannerFooterReusableView: UICollectionReusableView {
    
    static var identifier = "BannerFooterRV"
    
    private lazy var pageControl = UIPageControl().then {
        $0.hidesForSinglePage = true
        $0.currentPage = 3
        $0.currentPageIndicatorTintColor = .black
        $0.pageIndicatorTintColor = .lightGray
        $0.backgroundStyle = .prominent
    }
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     * - Description ViewModel에서 전달받은  `Observable`을 넘겨받아 pageControl의 UI정보를 업데이트하는 메서드
     * - Parameter data: 현재 배너의 페이지를 받을 `Observable`
     * - Parameter totalPage: 배너의 총페이지
     */
    func bind(to data: Observable<Int>, totalPage: Int) {
        pageControl.numberOfPages = totalPage
        
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] currentPage in
                self?.pageControl.currentPage = currentPage
            })
            .disposed(by: disposeBag)
    }
}
