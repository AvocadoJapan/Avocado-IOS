//
//  Variant.swift
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
    
    var buyerDescription: String {
        switch self {
        case .unused:
            return "한 번도 사용되지 않은 새 상품이에요."
        case .verified:
            return "아보카도가 직접 검수한 상품이에요. 아보카도 보증이 적용되는 상품이에요."
        case .fastShipping:
            return "당일또는 익일배송을 약속한 상품이에요."
        case .freeShipping:
            return "배송비 걱정 없이 무료로 배송돼요."
        case .premiumSeller:
            return "많은 구매자들이 만족한 판매자에요. 판매자의 매너, 후기 등을 종합적으로 고려해 선정된 프리미엄 판매자입니다."
        case .business:
            return "사업자등록을 한 판매자에요."
        case .avocadoPay:
            return "안전하고 간편한 아보카도페이로 구매 가능한 상품이에요."
        case .refundable:
            return "상품에 문제가 있을 때는 걱정없이 환불받으실 수 있어요."
        case .handmade:
            return "정성스럽게 손으로 만들어진 제품에요. 특별한 감성을 느껴보세요."
        }
    }
    
    var sellerDescription: String {
        switch self {
        case .unused:
            return "새상품이에요"
        case .verified:
            return "아보카도 검수를 이용해요."
        case .fastShipping:
            return "당일또는 익일배송일 가능해요."
        case .freeShipping:
            return "무료배송이 가능해요"
        case .premiumSeller:
            return "알 수 없음"
        case .business:
            return "알 수 없음"
        case .avocadoPay:
            return "아보카도페이를 이용해요"
        case .refundable:
            return "환불가능 상품이에요"
        case .handmade:
            return "핸드메이드 상풍이에요"
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
 * - Description 계정센터 타입 정보 셀에 대한 행동 정보를 담음
 */
enum AccountCenterDataType: CaseCountable {
    case findEmail
    case findPassword
    
    case accountLocked
    case confirmCodeUnvalid
    case code2FAUnvalid
    
    case contactCustomerCenter
    case accountHacked
    case accountDelete
    
    var title: String {
        switch self {
        case .findEmail: return "이메일이 기억나지 않아요"
        case .findPassword: return "비밀번호가 기억나지 않아요"
        case .accountLocked: return "계정이 비활성화 되었어요"
        case .confirmCodeUnvalid: return "확인코드가 유효하지 않아요"
        case .code2FAUnvalid: return "2FA인증에 접근할 수 없어요"
        case .contactCustomerCenter: return "고객센터"
        case .accountHacked: return "계정이 해킹된것 같아요"
        case .accountDelete: return "계정을 지우고 싶어요"
        }
    }
    
    var isHighlight: Bool {
        switch self {
        case .accountHacked: return true
        case .accountDelete: return true
        default: return false
        }
    }
}

/**
 * - Description 메인화면 및 상품 상세화면등에서 법률정보 표시를 위한 상수
 */
enum LegalType {
    static let title: String = "주식회사 아보카도 사업자정보, 이용약관 및 기타 법적고지".localized()
    static let discription: String = "주식회사 아보카도(이하 아보카도)는 통신판매중개자이며, 통신판매의 당사자가 아닙니다. 전자상거래 등에서의 소비자보호에 관한 법률 등 관련 법령 및 아보카도의 약관에 따라 상품, 상품정보, 거래에 관한 책임은 개별 판매자에게 귀속하고, 아보카도는 원칙적으로 회원간 거래에 대하여 책임을 지지 않습니다. 다만, 아보카도가 직접 판매하는 상품에 대한 책임은 아보카도에게 귀속합니다.".localized()
    static let copyright: String = "Copyright 2023 AvocadoLabs All RIGHTS RESERVED".localized()
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
