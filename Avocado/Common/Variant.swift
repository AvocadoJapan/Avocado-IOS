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
    static var success = Self(textColor: .green, bgColor: .systemBlue)
    static var warning = Self(textColor: .yellow, bgColor: .cyan)
    static var failure = Self(textColor: .red, bgColor: .white)
}

struct buttonColorType {
    var tintColor : UIColor
    var bgColor : UIColor
    
    init(tintColor: UIColor = .white,
         bgColor: UIColor = .black) {
        self.tintColor = tintColor
        self.bgColor = bgColor
    }
    
    static var primary = Self(tintColor: .white, bgColor: .black)
    static var secondary = Self(tintColor: .black, bgColor: .white)
    static var success = Self(tintColor: .white, bgColor: .systemBlue)
    static var danger = Self(tintColor: .white, bgColor: .systemRed)
    static var warning = Self(tintColor: .white, bgColor: .systemYellow)
    static var info = Self(tintColor: .white, bgColor: .systemCyan)
}

struct RegVarient {
    var regularExpression : String
    
    init(regularExpression : String = "") {
        self.regularExpression = regularExpression
    }
    
    static var email = Self(regularExpression: "[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}") // 영어 대문자금지의 이메일 정규식
    static var password = Self(regularExpression:  "(?=.*[A-Z])[A-Za-z0-9]{8,50}") // 8자리 ~ 50자리 1자리 이상의 영어 대문자, 영어+숫자
    static var nickname = Self(regularExpression: "[a-zA-Zぁ-んァ-ヶ一-龠々ー0-9]{3,10}") // 3~10자리의 특수문자 금지, 영문 일본어 숫자 가능
}
