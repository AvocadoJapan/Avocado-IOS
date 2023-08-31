//
//  Color.swift
//  Avocado
//
//  Created by Jayden Jang on 2023/06/24.
//


/**
 - Description: 화면에 직접적으로 관여하는 상수를 Variant로 분리
 */
import Foundation
import UIKit

/**
 - Description: 자사 컬러디자인 모음
 */
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
        case .warning: return .black
        case .success, .danger: return .white
        case .secondary: return .white
        case .info: return .black
        }
    }

    var bgColor: UIColor {
        switch self {
        case .primary, .danger, .warning: return .black
        case .secondary: return .systemGray
        case .success: return .systemBlue
        case .info: return .clear
        }
    }
}

/**
 - Description: 정규식 체크 룰
 */
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

/**
 - Description: 메인화면 서브메뉴 enum (정적인 데이터이므로 enum으로 정의)
 */
enum MainSubMenuType: CaseCountable {
    
    case favorite
    case recent
    case nearCurrentLocation
    case community
    case bargain
    case customerCenter
    
    var imageName: String {
        switch self {
        case .favorite: return "heart_solid"
        case .recent: return "clock_solid"
        case .nearCurrentLocation: return "location_solid"
        case .community: return "users_solid"
        case .bargain: return "bolt_solid"
        case .customerCenter: return "support_solid"
        }
    }
    
    var title: String {
        switch self {
        case .favorite: return "찜목록" //찜목록
        case .recent: return "최근본상품" //최근본상품
        case .nearCurrentLocation: return "근처상품" //근처상품
        case .community: return "동네고수" //동네고수
        case .bargain: return "급처상품" //급처상품
        case .customerCenter: return "고객센터" //고객센터
        }
    }
    
    var navigateTo: String {
        switch self {
        case .favorite: return "./"
        case .recent: return "./"
        case .nearCurrentLocation: return "./"
        case .community: return "./"
        case .bargain: return "./"
        case .customerCenter: return "./"
        }
    }
}

/**
 - Description: 상품 설명 요약 배지 enum
 */
enum ProductBadge {
    case unused
    case verified
    case fastShipping
    case freeShipping
    case premiumSeller
    case business
    case avocadoPay
    case refundable
    case handmade
    
    var title: String {
        switch self {
        case .unused: return "새 상품"
        case .verified: return "인증된 상품"
        case .fastShipping: return "빠른 배송"
        case .freeShipping: return "무료 배송"
        case .premiumSeller: return "프리미엄 판매자"
        case .business: return "개인사업자"
        case .avocadoPay: return "안전한 거래"
        case .refundable: return "환불 가능"
        case .handmade: return "핸드메이드 상품"
        }
    }
    
    var description: String {
        switch self {
        case .unused:
            return "이 상품은 한 번도 사용되지 않은 새 상품이에요."
        case .verified:
            return "아보카도가 직접 검수한 상품이에요. 아보카도 보증이 적용되는 상품이에요."
        case .fastShipping:
            return "판매자님이 당일또는 익일배송을 약속한 상품이에요."
        case .freeShipping:
            return "이 상품은 배송비 걱정 없이 무료로 배송돼요."
        case .premiumSeller:
            return "많은 구매자들이 만족한 판매자에요. 판매자의 매너, 후기 등을 종합적으로 고려해 선정된 프리미엄 판매자입니다."
        case .business:
            return "공식적으로 사업자등록을 한 판매자에요."
        case .avocadoPay:
            return "안전하고 간편한 아보카도페이로 구매 가능한 상품이에요."
        case .refundable:
            return "상품에 문제가 있을 때는 걱정없이 환불받으실 수 있어요."
        case .handmade:
            return "이 상품은 정성스럽게 손으로 만들어진 제품에요. 특별한 감성을 느껴보세요."
        }
    }
    
    var image: String {
        switch self {
        case .unused: return "hands-holding-circle-solid"
        case .verified: return "certificate-solid"
        case .fastShipping: return "truck-fast-solid"
        case .freeShipping: return "dollar-sign-solid"
        case .premiumSeller: return "star-solid"
        case .business: return "passport-solid"
        case .avocadoPay: return "shield-solid"
        case .refundable: return "rotate-left-solid"
        case .handmade: return "hand-holding-heart-solid"
        }
    }
}

/**
 - Description: 유저 요약 배지 enum
 */
enum UserBadge: Equatable {
    case premiumSeller
    case premiumBuyer
    case verified
    case unverified
    case comment(number: Int)
    
    var description: String {
        switch self {
        case .premiumSeller: return "프리미엄 판매자"
        case .premiumBuyer: return "프리미엄 구매자"
        case .verified: return "본인인증 완료"
        case .unverified: return "본인인증 미완료"
        case .comment(let number): return "거래후기 \(number)"
        }
    }
    
    var image: String {
        switch self {
        case .premiumSeller: return "certificate-solid"
        case .premiumBuyer: return "face-smile-solid"
        case .verified: return "check-solid"
        case .unverified: return "triangle-exclamation-solid"
        case .comment: return "comment-dots-solid"
        }
    }
}

/**
 - Description: 유저 권한 enum (현재 사용하지 않음)
 */
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
