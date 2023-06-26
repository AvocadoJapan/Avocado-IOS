//
//  KeychainUtil.swift
//  Avocado
//
//  Created by NUNU:D on 2023/06/20.
//

import Foundation
/**
 * - Description: Keychain CRUD 유틸클래스
 */
final class KeychainUtil {
    
    @discardableResult
    static func create(serviceName: String, account: String, token: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecValueData as String: token.data(using: .utf8) as Any
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            Logger.e("Keychain Create Error \n [Message]: \(String(describing: SecCopyErrorMessageString(status, nil)))")
            return false
        }
        
        return true
    }
    
    @discardableResult
    static func read(serviceName: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true,
            kSecReturnAttributes as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            Logger.e("KeyChain item Not Fount \n [Message]: \(String(describing: SecCopyErrorMessageString(status, nil)))")
            return nil
        }
        
        guard status == errSecSuccess else {
            Logger.e("KeyChain item read Error \n [Message]: \(String(describing: SecCopyErrorMessageString(status, nil)))")
            return nil
        }
        
        guard let existingItem = item as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data,
              let token = String(data: tokenData, encoding: .utf8) else {
            Logger.e("Keychain get token Faild \n [Message]: \(String(describing: SecCopyErrorMessageString(status, nil)))")
            return nil
        }
        
        return token
    }
    
    @discardableResult
    static func update(serviceName: String, account: String, token: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let attributes: [String: Any] = [
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecValueData as String: token.data(using: .utf8) as Any
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else {
            Logger.e("Keychain item Not Found \n [Message]: \(String(describing: SecCopyErrorMessageString(status, nil)))")
            return false
        }
        guard status == errSecSuccess else {
            Logger.e("Keychain update Error \n [Message]: \(String(describing: SecCopyErrorMessageString(status, nil)))")
            return false
        }
        
        return true
    }
    
    @discardableResult
    static func delete(serviceName: String, account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            Logger.e("Keychain delete Error \n [Message]: \(String(describing: SecCopyErrorMessageString(status, nil)))")
            return false
        }
        
        return true
        
    }
}

extension KeychainUtil {
    
    @discardableResult
    static func loginTokenCreate(accessToken: String, refreshToken: String) -> Bool {
        let isAccessTokenCreate = create(serviceName: "", account: "", token: accessToken)
        let isRefreshTokenCreate = create(serviceName: "", account: "", token: refreshToken)
        
        return isAccessTokenCreate && isRefreshTokenCreate
    }
    
    static func loginTokenRead() -> String? {
        return read(serviceName: "", account: "")
    }
    
    static func loginTokenUpdate(token: String) -> Bool {
        return update(serviceName: "", account: "", token: token)
    }
    
    static func loginTokenDelete() -> Bool {
        return delete(serviceName: "", account: "")
    }
}

