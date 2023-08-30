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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        
        self.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
