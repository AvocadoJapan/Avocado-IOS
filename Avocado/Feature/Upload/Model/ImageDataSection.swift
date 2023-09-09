//
//  ImageDataSection.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/09/03.
//

import Foundation
import Differentiator
import UIKit

struct ImageDataSection {
    var imageOrderNum: Int? // 몇번째 요소인지, 추후 변경 필요
    var items: [UIImage]
}

extension ImageDataSection: SectionModelType {
    typealias Item = UIImage

    init(original: ImageDataSection, items: [Item]) {
        self = original
        self.items = items
    }
}
