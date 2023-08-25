//
//  SubButton.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/07/02.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class SubButton: UIButton {
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    convenience init(text : String,
                     fontSize: CGFloat = 14,
                     weight: UIFont.Weight = .medium){
        self.init(frame: .zero)
        
        setTitle(text, for: .normal)
        titleLabel?.numberOfLines = 0
        contentHorizontalAlignment = .right
        setTitleColor(.darkGray, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        tintColor = .darkGray
        
        // SFSymbol 설정
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium)
        let symbol = UIImage(systemName: "chevron.left.2", withConfiguration: symbolConfig)
        setImage(symbol, for: .normal)
        
        // 이미지와 텍스트 간격 설정
        let spacing: CGFloat = 5.0 // 원하는 간격으로 조절
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

