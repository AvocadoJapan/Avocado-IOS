//
//  LegalFooterReuseableView.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/21.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
/**
 *## 화면명: 법률정보를 담고있는 리갈 푸터뷰, 컬렉션뷰 또는 테이블뷰로 구성된 컨포지셔널레이아웃에서 사용
 */
final class LegalFooterReuseableView: UICollectionReusableView {
    
    static var identifier = "LegalFooterRV"
    
    lazy var titleLabel = UILabel().then {
        $0.text = LegalType.title
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        $0.textColor = .darkGray
    }
    
    lazy var discriptionLabel = UILabel().then {
        $0.text = LegalType.discription
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        $0.textColor = .systemGray
    }
    
    lazy var copyrightLabel = UILabel().then {
        $0.text = LegalType.copyright
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        $0.textColor = .systemGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setProperty()
        setLayout()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setProperty() {
        backgroundColor = .systemGray6
    }
    
    private func setLayout() {
        
    }
    
    private func setConstraint() {
        
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//    }
}

// MARK: - Preview 관련
#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct LegalFooterReuseableViewPreview: PreviewProvider {
    static var previews: some View {
        return LegalFooterReuseableView().toPreview().previewLayout(.fixed(width: 414, height: 200))
    }
}
#endif



