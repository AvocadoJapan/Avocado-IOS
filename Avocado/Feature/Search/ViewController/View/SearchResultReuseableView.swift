//
//  SearchResultReuseableView.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/28.
//

import UIKit
import RxRelay
import RxSwift

final class SearchResultReuseableView: UICollectionReusableView {
    static var identifier = "SearchResultReuseableView"
    
    private lazy var mainContainerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.layoutMargins = UIEdgeInsets(
            top: 10,
            left: 10,
            bottom: 0,
            right: 10
        )
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var categoryContainerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    private lazy var categoryScollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "iphone 13 검색결과"
        $0.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        $0.numberOfLines = 0
        $0.textColor = .black
    }
    
    // 카테고리 클릭 시 옵저버블 이벤트
    var categoryTapPublish = PublishSubject<String>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // set Layout
        categoryScollView.addSubview(categoryContainerStackView)
        
        [categoryScollView, titleLabel].forEach {
            mainContainerStackView.addArrangedSubview($0)
        }
        
        addSubview(mainContainerStackView)
        
        // set Constraint
        categoryScollView.snp.makeConstraints {
            $0.height.equalTo(categoryContainerStackView)
        }
        
        categoryContainerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainContainerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var disposeBag = DisposeBag()
    
    func configure(title: String, categories: [String] = []) {
        // 카테고리 값이 존재하지 않는 경우 hidden
        categoryScollView.isHidden = categories.isEmpty
        
        // 이미 셀이 그려진 경우에는 다시 그리지 않음
        if categoryContainerStackView.arrangedSubviews.count == 0 {
            categories
                .map { return CategoryView(title: $0) }
                .forEach {
                    categoryContainerStackView.addArrangedSubview($0)
                    
                    // 셀 높이 40으로 고정
                    $0.snp.makeConstraints {
                        $0.height.equalTo(40)
                    }
                    
                    // 셀 클릭한 정보 퍼블리시 이벤트로 전달
                    $0.tapPublish
                        .bind(to: categoryTapPublish)
                        .disposed(by: disposeBag)
                }
        }
        
        titleLabel.text = "\(title) 검색결과"
    }
    
}
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct SearchResultReuseableViewPreview: PreviewProvider {
    static var previews: some View {
        return SearchResultReuseableView()
            .toPreview()
            .previewLayout(
                .fixed(
                    width: 414,
                    height: 100
                )
            )
    }
}
#endif
