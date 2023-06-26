//
//  BaseResponse.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/20.
//

import Foundation

/**
 * - Description: 페이징 처리가 필요한 API의 BaseResponse 객체
 * - Warning: 페이징 처리가 필요하지 않은 객체는 사용하지 말아야 함!
 * ```
 * //example for Moya
 * provider
 * .rx
 * .request(targetType)
 * .map(BasePagenationResponse<APIResponseType>.self)
 *
 * ```
 */
struct BasePagenationResponse<T: Decodable>: Decodable {
    let nextToken: Int? // 다음페이지 여부
    let items: T // 페이징 객체 (제네릭 선언)
    
    enum CodingsKeys: String, CodingKey {
        case nextToken = "nextToken"
        case items = "items"
    }
}
