//
//  UILabel+Extension.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/10/02.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(labelAprearance: AvocadoLabel) {
        self.init()
        self.font = labelAprearance.font
        self.textColor = labelAprearance.color
    }
}
