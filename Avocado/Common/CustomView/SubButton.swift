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
    
    convenience init(text : String){
        self.init(frame: .zero)
        
        self.setTitle(text + " >", for: .normal)
        self.titleLabel?.numberOfLines = 0
        self.contentHorizontalAlignment = .right
        self.setTitleColor(.darkGray, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        //MARK: - UI 설정
        self.snp.makeConstraints {
            $0.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
