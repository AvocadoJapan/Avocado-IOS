//
//  ContourView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/08/27.
//

import Foundation
import UIKit
import SnapKit

final class ContourView: UIView {
    
    // 구분선 화면
    private lazy var lineView = UIView().then {
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 0.5
    }
    
    init(inset: UIEdgeInsets) {
        super.init(frame: .zero)
        setLayout()
        setConstraint(inset: inset)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraint()
    }
    
    private func setLayout() {
        addSubview(lineView)
    }
    
    /**
     * - description 오토레이아웃 설정 메서드로 파라미터 값을 받아 인셋을 정해줄 수 있도록 구성
     * - parameter inset lineView의 inset값 기본값은 0
     */
    private func setConstraint(inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        lineView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(inset)
            $0.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
