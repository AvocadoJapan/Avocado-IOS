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

struct ButtonColorType {
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

struct PrivacyType {
    var title : String
    var discription: String
    
    init(title : String = "",
         discription : String = "") {
        self.title = title
        self.discription = discription
    }
    
    static var notification = Self(title: "알림 (선택)", discription: "메세지 알림, 광고 알림 등")
    static var location = Self(title: "위치 서비스 (선택)", discription: "부정가입 방지, 위치 기반 추천 서비스 등")
    static var contacts = Self(title: "연락처 (선택)", discription: "unknown")
    static var calendars = Self(title: "캘린더 (선택)", discription: "약속 추가 등")
    static var reminders = Self(title: "미리 알림 (선택)", discription: "")
    static var photos = Self(title: "사진 (선택)", discription: "상품 사진 등록, 프로필 사진 등")
    static var bluetooth = Self(title: "Bluetooth (선택)", discription: "unknown")
    static var localNetwork = Self(title: "로컬 네트워크 (선택)", discription: "unknown")
    static var nearbyInteractions = Self(title: "unknown (선택)", discription: "unknown")
    static var microphone = Self(title: "마이크 (선택)", discription: "아보카도 통화 등")
    static var speechRecognition = Self(title: "음성 인식(선택) ", discription: "unknown")
    static var camera = Self(title: "카메라 (선택)", discription: "상품 사진 촬영, 프로필 사진 등")
    static var health = Self(title: "건강 (선택)", discription: "unknown")
    static var researchSensor = Self(title: "리서치 센서 및 사용 데이터 (선택)", discription: "unknown")
    static var homeKit = Self(title: "HomeKit (선택)", discription: "unknown")
    static var media = Self(title: "미디어 및 Apple Music (선택)", discription: "unknown")
    static var files = Self(title: "파일 및 폴더 (선택)", discription: "unknown")
    static var motion = Self(title: "동작 및 피트니스 (선택)", discription: "unknown")
    static var focus = Self(title: "집중 모드 (선택)", discription: "unknown")
}
