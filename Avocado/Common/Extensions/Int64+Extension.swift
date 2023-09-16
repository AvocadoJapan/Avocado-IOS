//
//  Int64+Extension.swift
//  Avocado
//
//  Created by NUNU:D on 2023/09/03.
//

import Foundation

extension Int64 {
    /**
     * - description unix 시간으로 되어있는 날짜를 포맷에 맞춰 String으로 변환해주는 함수
     */
    func dateFormatForUNIX(format: String) -> String {
        let fomatter = DateFormatter()
        fomatter.dateFormat = format
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return fomatter.string(from: date)
    }
    
    /**
     * - description 세자리 수 마다 ,(콤마) 표시 함수
     */
    func decimalString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
}
