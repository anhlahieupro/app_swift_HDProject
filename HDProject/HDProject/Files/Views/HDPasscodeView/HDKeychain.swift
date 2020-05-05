import Foundation
import Security

// MARK: - Save value to Keychain

public struct HDKeychain {
    private static let kSecClassValue                = NSString(format: kSecClass)
    private static let kSecAttrAccountValue          = NSString(format: kSecAttrAccount)
    private static let kSecValueDataValue            = NSString(format: kSecValueData)
    private static let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
    private static let kSecAttrServiceValue          = NSString(format: kSecAttrService)
    private static let kSecMatchLimitValue           = NSString(format: kSecMatchLimit)
    private static let kSecReturnDataValue           = NSString(format: kSecReturnData)
    private static let kSecMatchLimitOneValue        = NSString(format: kSecMatchLimitOne)
}

public extension HDKeychain {
    static func updatePassword(service: String, account: String, data: String) {
        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let objects = [kSecClassGenericPasswordValue, service, account] as [Any]
            let keys = [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue]
            let keychainQuery = NSMutableDictionary(objects: objects, forKeys: keys)
            let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue:dataFromString] as CFDictionary)
            if #available(iOS 11.3, *),
                status != errSecSuccess,
                let err = SecCopyErrorMessageString(status, nil) {
                print("Read failed: \(err)")
            }
        }
    }
    
    static func removePassword(service: String, account: String) {
        let objects = [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue ?? false] as [Any]
        let keys = [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue]
        let keychainQuery = NSMutableDictionary(objects: objects, forKeys: keys)
        let status = SecItemDelete(keychainQuery as CFDictionary)
        if #available(iOS 11.3, *),
            status != errSecSuccess,
            let err = SecCopyErrorMessageString(status, nil) {
            print("Remove failed: \(err)")
        }
    }
    
    static func savePassword(service: String, account: String, data: String) {
        removePassword(service: service, account: account)
        
        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let objects = [kSecClassGenericPasswordValue, service, account, dataFromString] as [Any]
            let keys = [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue]
            let keychainQuery = NSMutableDictionary(objects: objects, forKeys: keys)
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
            if #available(iOS 11.3, *),
                status != errSecSuccess,
                let err = SecCopyErrorMessageString(status, nil) {
                print("Write failed: \(err)")
            }
        }
    }
    
    static func getPassword(service: String, account: String) -> String? {
        let objects = [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue ?? false, kSecMatchLimitOneValue] as [Any]
        let keys = [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue]
        let keychainQuery = NSMutableDictionary(objects: objects, forKeys: keys)
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String?
        if status == errSecSuccess,
            let retrievedData = dataTypeRef as? Data {
            contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        return contentsOfKeychain
    }
}
