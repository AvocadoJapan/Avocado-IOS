//
//  CategoryView.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/14.
//

import UIKit
import RxSwift
import RxRelay

final class CategoryView: UIControl {
    
    private lazy var titleLabel = PaddingLabel(
        padding: UIEdgeInsets(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10)
    ).then {
        $0.text = "iphone 13"
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = true
        $0.textColor = .darkGray
    }
    
    var tapPublish = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstriant()
        bindUI()
    }
    
    init(title: String) {
        super.init(frame: .zero)
        setLayout()
        setConstriant()
        bindUI()
        titleLabel.text = title
    }
    
    private func setLayout() {
        addSubview(titleLabel)
    }
    
    private func setConstriant() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindUI() {
        // 클릭 이벤트
        rx.controlEvent(.touchUpInside)
            .asDriver()
            .throttle(.seconds(3), latest: false)
            .drive(onNext: { [weak self] in
                self?.tapPublish.onNext(self?.titleLabel.text ?? "")
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct CatecogyCVCellPreview: PreviewProvider {
    static var previews: some View {
        return CategoryView()
            .toPreview()
            .previewLayout(
                .fixed(
                    width: 100,
                    height: 40
                )
            )
    }
}
#endif
