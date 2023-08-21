//
//  Responseable.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/20.
//

import Foundation

/**
 * - Description: DTO객체를 가지고있는 Response객체가 가지고있을 Base 프로토콜
 * 상속받은 객체는 associatedType인`DTO`를 이용하여 DTO객체 타입을 정의 함
 * 객체타입을 지정하면 `toDTO`메서드를 사용하여 쉽게 DTO 객체를 만들 수 있음
 */
protocol DTOResponseable: Decodable {
    associatedtype DTO: Decodable
    func toDTO() -> DTO
}
