//
//  BottomButtonBarView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/10/06.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa
import SPIndicator

/**
 * - description: 단일상품화면에서 좋아요, 구매하기 등 버튼이 있는 하단 고정 뷰
 */
final class BottomButtonBarView: UIView {
    
    // 버튼 스택뷰
    private lazy var buttomButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.backgroundColor = .white
    }
    private lazy var favButton = BottomButton(text: "좋아요", buttonType: .info)
    private lazy var purchaseButton = BottomButton(text: "결제하기", buttonType: .primary)
    private lazy var dmButton = BottomButton(text: "채팅하기", buttonType: .secondary)
    // 뷰 상단 구분선
    private lazy var contourView = ContourView()
    // 디스포즈백
    public var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bindUI()
        setProperty()
        setLayout()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindUI() {
        favButton
            .rx
            .tap
            .subscribe { _ in
                SPIndicator.present(title: "시스템 에러", message: "지원하지 않는 기능", preset: .error, haptic: .error)
            }
            .disposed(by: disposeBag)
        
        dmButton
            .rx
            .tap
            .subscribe { _ in
                SPIndicator.present(title: "시스템 에러", message: "지원하지 않는 기능", preset: .error, haptic: .error)
            }
            .disposed(by: disposeBag)
        
        purchaseButton
            .rx
            .tap
            .subscribe { _ in
                SPIndicator.present(title: "시스템 에러", message: "지원하지 않는 기능", preset: .error, haptic: .error)
            }
            .disposed(by: disposeBag)
    }
    
    private func setProperty() {
        backgroundColor = .white
    }
    
    private func setLayout() {
        addSubview(buttomButtonStackView)
        addSubview(contourView)
        
        [favButton, dmButton, purchaseButton].forEach {
            buttomButtonStackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraint() {
        contourView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        buttomButtonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI

struct BottomButtonBarViewPreview: PreviewProvider {
    static var previews: some View {
        return BottomButtonBarView().toPreview().previewLayout(.fixed(width: 394, height: 70))
    }
}
#endif
