//
//  ProductGroupFooterReusableView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/24.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

/**
 *## 화면명: 상품 그룹 푸터 ReusableView (더보기 버튼)
 *## 누를 경우 이펙트: 그 상품그룹의 ID 값으로 6개가 아닌 전체 정보를 보여주는 VC로 이동
 */
final class ProductGroupFooterReusableView: UICollectionReusableView {
    
    static var identifier = "ProductGroupFooterRV"
    
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
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(data: Observable<Int>,
                          totalPage: Int) {
        pageControl.numberOfPages = totalPage
        data
            .observe(on: MainScheduler.instance)
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
    }
}
