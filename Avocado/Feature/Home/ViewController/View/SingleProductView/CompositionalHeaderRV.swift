//
//  CompositionalHeaderRV.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/10/06.
//

import UIKit
import RxSwift

/**
 *## description: 컴포지셔널 뷰의 제목을 담을 헤더
 *## function : 제목
 */
final class CompositionalHeaderRV: UICollectionReusableView {
    
    // 식별자 스태틱으로 선언
    static var identifier = "CompositionalHeaderRV"
    // 디스포즈백
    public var disposeBag = DisposeBag()
    
    private lazy var titleLabel = UILabel(labelAprearance: .sectionTitle).then {
        $0.text = "업로더 정보"
        $0.numberOfLines = 1
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setLayout() {
        addSubview(titleLabel)
    }
    
    private func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI
import RxSwift
struct CompositionalHeaderRVPreview: PreviewProvider {
    static var previews: some View {
        return CompositionalHeaderRV().toPreview().previewLayout(.fixed(width: 375, height: 50))
    }
}
#endif

