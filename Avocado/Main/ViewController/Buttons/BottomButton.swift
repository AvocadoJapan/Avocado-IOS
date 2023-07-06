//
//  BottomButton.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/28.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class BottomButton : UIButton {
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    convenience init(text : String,
                     buttonType : ButtonColorType = .primary){
        self.init(frame: .zero)
        
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.layer.cornerRadius = 20
        
        self.backgroundColor = buttonType.bgColor
        self.setTitleColor(buttonType.tintColor, for: .normal)
        
        //MARK: - UI 설정
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

