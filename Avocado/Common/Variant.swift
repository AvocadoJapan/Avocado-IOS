//
//  Color.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/24.
//

import Foundation
import UIKit

struct ColorVariant {
    var textColor : UIColor
    var bgColor : UIColor
    
    init(textColor: UIColor = .black,
         bgColor: UIColor = .white) {
        self.textColor = textColor
        self.bgColor = bgColor
    }
    
    static var normal = Self(textColor: .darkGray, bgColor: .systemGray6)
//    static var success = Self(textColor: .green, bgColor: .systemBlue)
//    static var warning = Self(textColor: .yellow, bgColor: .cyan)
//    static var failure = Self(textColor: .red, bgColor: .white)
}

struct regVarient {
    var regularExpression : String
    
    init(regularExpression : String = "asdfasdfasdf") {
        self.regularExpression = regularExpression
    }
    static var email = Self(regularExpression: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    static var password = Self(regularExpression: "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}") // 8자리 ~ 50자리 영어+숫자+특수문자
    static var nickname = Self(regularExpression: "{3,10}")
}
