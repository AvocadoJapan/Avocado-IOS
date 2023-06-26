//
//  NetworError.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/20.
//

import Foundation

/**
 * - Description  Network관련 오류 enum
 * `invaildResponse` :  Response가 잘못되었을 경우
 * `tokenExpired`:  토큰이 만료가 되었을 경우
 * `unknown`: 그 외 오류가 발생했을 경우 `code`값과 `message`값을 넣어표시
 */
enum NetworkError: Error {
    case invaildResponse
    case tokenExpired
    case unknown(_ code: Int, _ message: String)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invaildResponse:
            return "Response가 잘못 되었습니다"
            
        case .tokenExpired:
            return "토큰이 만료되었습니다"
            
        case .unknown(let code, let message):
            return "오류 코드 : \(code)\n 오류 메시지 \(message)"
        }
    }
}
