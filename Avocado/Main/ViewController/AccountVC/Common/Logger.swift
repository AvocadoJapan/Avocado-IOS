//
//  Logger.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/20.
//

import Foundation
/**
 * - Description: Log Level에 따른 Logger메서드
 */
final class Logger {
    public static func d(_ msg:Any, file:String = #file, function:String = #function, line:Int = #line) {
#if DEBUG
        let fileName = file.split(separator: "/").last ?? ""
        let functionName = function.split(separator: "(").first ?? ""
        print("✅ [DEBUG] : [\(Date())] [\(fileName)] \(functionName)(\(line)) : \(msg)")
#endif
    }
    
    public static func i(_ msg:Any, file:String = #file, function:String = #function, line:Int = #line) {
#if DEBUG
        let fileName = file.split(separator: "/").last ?? ""
        let functionName = function.split(separator: "(").first ?? ""
        print("ℹ️ [INFO] : [\(Date())] [\(fileName)] \(functionName)(\(line)) : \(msg)")
#endif
    }
    
    public static func e(_ msg:Any, file:String = #file, function:String = #function, line:Int = #line) {
        let fileName = file.split(separator: "/").last ?? ""
        let functionName = function.split(separator: "(").first ?? ""
        print("🚫 [ERROR] : [\(Date())] [\(fileName)] \(functionName)(\(line)) : \(msg)")
    }
    
    public static func trace(_ message: String, function: String = #function, line: Int = #line) {
        let funcName = function.split(separator: "(").first ?? ""
        print("💬 [TRACE] : [\(message)] \(funcName):\(line)")
    }
}

