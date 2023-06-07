//
//  MainHeaderRV.swift
//  Avocado
//
//  Created by 최현우 on 2023/06/03.
//

import UIKit
/**
 * ##화면명: 메인 상품정보 상단에 타이블 헤더
 */
final class MainHeaderRV: UICollectionReusableView {
    static var identifier = "MainHeaderRV"
    
    private lazy var titleLabel = UILabel().then {
        $0.text = """
                    もふもふの
                    お友達
                    """
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.numberOfLines = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.top.bottom.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init Error")
    }
    
    /**
     * - Description 헤더 타이틀 UILabel 값을 업데이트하는 함수
     * - Parameter title: 업데이트할 헤더 타이틀 값
     */
    public func configureTitle(to title:String) {
        titleLabel.text = title
    }
}
