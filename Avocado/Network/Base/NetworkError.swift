//
//  NetworError.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/20.
//

import Foundation
/**
 * - Description  Avocado 에러 프로토콜 {errDescription을 사용하기 위한 프로토콜, 에러는 모두 이 프로토콜을 가져야함}
 */
protocol AvocadoError: Error {
    var errorDescription: String {get}
}

/**
 * - Description  Network관련 오류 enum
 * `invaildResponse` :  Response가 잘못되었을 경우
 * `tokenExpired`:  토큰이 만료가 되었을 경우
 * `invaildURL`:  URLRequest에 매핑하지 못한 경우
 * `pageNotFound`:  사용자가 없는경우, page를 잘못 호출 한 경우
 * `unknown`: 그 외 오류가 발생했을 경우 `code`값과 `message`값을 넣어표시
 */
enum NetworkError: AvocadoError {
    case invaildResponse
    case tokenExpired
    case tokenIsRequired
    case invaildURL
    case pageNotFound
    case serverError
    case serverConflict
    case unknown(_ code: Int, _ message: String)
    
    var errorDescription: String {
        switch self {
        case .invaildResponse:
            return "Response가 잘못 되었습니다"
            
        case .tokenExpired:
            return "토큰이 만료되었습니다"
            
        case .tokenIsRequired:
            return "토큰이 필요합니다"
            
        case .invaildURL:
            return "서버 요청에 실패하였습니다"
            
        case .pageNotFound:
            return "경로가 잘못 되었습니다 \n 앱을 다시 실행해주세요"
            
        case .serverError:
            return "서버 오류 입니다"
            
        case .serverConflict:
            return "중복된 요청입니다"
            
        case .unknown(let code, let message):
            return "오류 코드 : \(code)\n 오류 메시지 \(message)"
        }
    }
}
/**
 * - Description  사용자 관련 오류 내용 { Amplify 오류 컨버팅.. 외 등등}
 */
enum UserAuthError: AvocadoError {
    /// `Token` 관련
    case deleteTokenFailed // 키체인 토큰 삭제에 실패한 경우
    case updateTokenFailed // 키체인 토큰 업데이트에 실패한 경우
    case createTokenFailed // 키체인 토큰 생성에 실패한 경우
    
    /// `Login`관련
    case userSocialLoginCanceled // 유저가 소셜로그인을 취소한 경우 {Apple 로그인의 경우 소셜 로그인 취소시 처리가 필요}
    case userEmailExists //이메일이 존재하는 경우
    case userNotFound // 유저가 존재하지 않을 경우
    case userLoginFailed // 로그인에 실패한 경우
    case userLogoutFailed // 로그아웃에 실패한 경우
    case emailNotConfirmed // 이메일 인증이 되지 않은 계정으로 접근 시도 할 경우
    case emailConfirmCodeMisMatch // 인증번호가 올바르지 않은 경우
    case emailConfirmCodeExpired // 만료된 인증번호로 접근 시도 할 경우
    case userNickNameDuplicated // 중복된 닉네임이 존재하는 경우
    case unknown(message: String) // 그 외 오류
    
    var errorDescription: String {
        switch self {
        case .createTokenFailed:
            return "토큰 생성에 실패하였습니다"
            
        case .updateTokenFailed:
            return "토큰 업데이트에 실패하였습니다"
            
        case .deleteTokenFailed:
            return "토큰 삭제에 실패하였습니다"
            
        case .userEmailExists:
            return "이미 가입한 계정이 존재합니다"
            
        case .userSocialLoginCanceled:
            return "소셜 로그인을 취소합니다"
            
        case .userNotFound:
            return "유저가 존재하지 않습니다"
            
        case .userLoginFailed:
            return "로그인에 실패 하였습니다"
            
        case .userLogoutFailed:
            return "로그아웃에 실패 하였습니다"
            
        case .emailNotConfirmed:
            return "이메일 인증이 되지 않은 계정입니다"
            
        case .emailConfirmCodeMisMatch:
            return "이메일 인증번호가 올바르지 않습니다"
            
        case .emailConfirmCodeExpired:
            return "만료된 인증번호 입니다"
            
        case .userNickNameDuplicated:
            return "중복된 닉네임이 존재합니다"
            
        case .unknown(let message):
            return message
        }
    }
    
}
