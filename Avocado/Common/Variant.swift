//
//  Color.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/24.
//

import Foundation
import UIKit

enum ColorVariant {
    case normal
    case success
    case warning
    case failure

    var textColor: UIColor {
        switch self {
        case .normal: return .darkGray
        case .success: return .green
        case .warning: return .yellow
        case .failure: return .red
        }
    }

    var bgColor: UIColor {
        switch self {
        case .normal: return .systemGray6
        case .success: return .systemBlue
        case .warning: return .cyan
        case .failure: return .white
        }
    }
}

enum ButtonColorType {
    case primary
    case secondary
    case success
    case danger
    case warning
    case info

    var tintColor: UIColor {
        switch self {
        case .primary: return .white
        case .secondary, .warning, .info: return .black
        case .success, .danger: return .white
        }
    }

    var bgColor: UIColor {
        switch self {
        case .primary, .danger, .warning: return .black
        case .secondary: return .white
        case .success: return .systemBlue
        case .info: return .systemCyan
        }
    }
}

class Rule {
    let check: (String) -> Bool
    let errorMessage: String

    init(_ check: @escaping (String) -> Bool, _ errorMessage: String) {
        self.check = check
        self.errorMessage = errorMessage
    }
}

enum RegVarient {
    case email
    case password
    case nickname

    var rules: [Rule] {
        switch self {
        case .email:
            return [
                Rule({ NSPredicate(format: "SELF MATCHES %@", "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: $0) }, "이메일 형식이 올바르지 않습니다."),
                Rule({ !$0.contains(where: { $0.isUppercase }) }, "이메일은 대문자를 사용할 수 없습니다."),
            ]
        case .password:
            return [
                Rule({ $0.count >= 8 && $0.count <= 50 }, "비밀번호는 8자 이상 50자 이하이어야 합니다."),
                Rule({ $0.rangeOfCharacter(from: .uppercaseLetters) != nil }, "비밀번호는 대문자를 하나 이상 포함해야 합니다."),
                Rule({ $0.rangeOfCharacter(from: .decimalDigits) != nil }, "비밀번호는 숫자를 하나 이상 포함해야 합니다."),
                Rule({ $0.rangeOfCharacter(from: .lowercaseLetters) != nil }, "비밀번호는 소문자를 하나 이상 포함해야 합니다."),
            ]
        case .nickname:
            return [
                Rule({ $0.count >= 3 && $0.count <= 10 }, "닉네임은 3~10자리 사이이어야 합니다."),
                Rule({ $0.rangeOfCharacter(from: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "ぁ-んァ-ヶ一-龠々ー")).inverted) == nil }, "닉네임에는 특수 문자를 사용할 수 없습니다."),
                Rule({ $0.rangeOfCharacter(from: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "ぁ-んァ-ヶ一-龠々ー"))) != nil }, "닉네임은 영문, 일본어, 숫자만 가능합니다."),
            ]
        }
    }
}

protocol CaseCountable: CaseIterable {
    static var count: Int { get }
}

extension CaseCountable {
    static var count: Int {
        return Self.allCases.count
    }
}

enum MainSubMenuType: CaseCountable {
    
    case favorite
    case recent
    case nearCurrentLocation
    case event
    case community
    case bargain
    case customerCenter
    
    var imageName: String {
        switch self {
        case .favorite: return "heart.fill"
        case .recent: return "clock.fill"
        case .nearCurrentLocation: return "location.fill"
        case .event: return "party.popper.fill"
        case .community: return "person.2.fill"
        case .bargain: return "bolt.badge.clock.fill"
        case .customerCenter: return "person.icloud.fill"
        }
    }
    
    var title: String {
        switch self {
        case .favorite: return "찜목록" //いいね
        case .recent: return "최근본상품" //閲覧履歴
        case .nearCurrentLocation: return "근처상품" //近くの商品
        case .event: return "이벤트" //キャンペーン
        case .community: return "동네고수" //達人
        case .bargain: return "급처상품" //注目商品
        case .customerCenter: return "고객센터" //事務局
        }
    }
    
    var navigateTo: String {
        switch self {
        case .favorite: return "./"
        case .recent: return "./"
        case .nearCurrentLocation: return "./"
        case .event: return "./"
        case .community: return "./"
        case .bargain: return "./"
        case .customerCenter: return "./"
        }
    }
}


enum PrivacyType {
    case notification
    case location
    case contacts
    case calendars
    case reminders
    case photos
    case bluetooth
    case localNetwork
    case nearbyInteractions
    case microphone
    case speechRecognition
    case camera
    case health
    case researchSensor
    case homeKit
    case media
    case files
    case motion
    case focus

    var title: String {
        switch self {
        case .notification: return "알림 (선택)"
        case .location: return "위치 서비스 (선택)"
        case .contacts: return "연락처 (선택)"
        case .calendars: return "캘린더 (선택)"
        case .reminders: return "미리 알림 (선택)"
        case .photos: return "사진 (선택)"
        case .bluetooth: return "Bluetooth (선택)"
        case .localNetwork: return "로컬 네트워크 (선택)"
        case .nearbyInteractions: return "unknown (선택)"
        case .microphone: return "마이크 (선택)"
        case .speechRecognition: return "음성 인식(선택) "
        case .camera: return "카메라 (선택)"
        case .health: return "건강 (선택)"
        case .researchSensor: return "리서치 센서 및 사용 데이터 (선택)"
        case .homeKit: return "HomeKit (선택)"
        case .media: return "미디어 및 Apple Music (선택)"
        case .files: return "파일 및 폴더 (선택)"
        case .motion: return "동작 및 피트니스 (선택)"
        case .focus: return "집중 모드 (선택)"
        }
    }

    var discription: String {
        switch self {
        case .notification: return "메세지 알림, 광고 알림 등"
        case .location: return "부정가입 방지, 위치 기반 추천 서비스 등"
        case .contacts, .bluetooth, .localNetwork, .nearbyInteractions, .speechRecognition, .health, .researchSensor, .homeKit, .media, .files, .motion, .focus, .reminders: return "unknown"
        case .calendars: return "약속 추가 등"
        case .photos: return "상품 사진 등록, 프로필 사진 등"
        case .microphone: return "아보카도 통화 등"
        case .camera: return "상품 사진 촬영, 프로필 사진 등"
        }
    }
}
