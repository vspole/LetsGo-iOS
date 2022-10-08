//
//  LocalStorageManager.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/7/22.
//

import Foundation

public protocol LocalStorageStandardStore {
    func set(_ value: Any?, forKey defaultName: String)
    func object(forKey defaultName: String) -> Any?
}

extension UserDefaults: LocalStorageStandardStore {}

public protocol LocalStorageManagerProtocol {
    func securelyStore(key: String, data: String)
    func securelyRetrieveData(key: String) -> String?
    func insecurelyStore(data: Any, forKey: String)
    func insecurelyRetrieveData<T>(forType: T.Type, withKey: String) -> Any?
    func insecurelyStore<T: Encodable>(encodable: T, forKey: String) throws
    func insecurelyRetrieve<T: Decodable>(withKey: String) throws -> T?
}

public class LocalStorageManager: LocalStorageManagerProtocol {
    let standardStore: LocalStorageStandardStore
    
    public init(standardStore: LocalStorageStandardStore = UserDefaults.standard) {
        self.standardStore = standardStore
    }
    
    public func securelyStore(key: String, data: String) {
        guard let data = data.data(using: String.Encoding.utf8) else { return }
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data ] as [String: Any]
        
        SecItemDelete(query as CFDictionary)
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    public func securelyRetrieveData(key: String) -> String? {
        let cfTrue: CFBoolean = kCFBooleanTrue
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: cfTrue,
            kSecMatchLimit as String: kSecMatchLimitOne ] as [String: Any]
        
        var retrievedData: AnyObject?
        _ = SecItemCopyMatching(query as CFDictionary, &retrievedData)
        
        guard let data = retrievedData as? Data else { return nil }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    public func insecurelyStore(data: Any, forKey: String) {
        UserDefaults.standard.set(data, forKey: forKey)
    }
    
    public func insecurelyRetrieveData<T>(forType: T.Type, withKey: String) -> Any? {
        switch forType {
        case is Bool.Type:
            return UserDefaults.standard.bool(forKey: withKey)
        case is String.Type:
            return UserDefaults.standard.string(forKey: withKey)
        default:
            return UserDefaults.standard.object(forKey: withKey) as? Data
        }
    }
    
    public func insecurelyStore<T: Encodable>(encodable: T, forKey: String) throws {
        let encoded = try JSONEncoder().encode(encodable)
        standardStore.set(encoded, forKey: forKey)
    }

    public func insecurelyRetrieve<T: Decodable>(withKey: String) throws -> T? {
        guard let loadedData = standardStore.object(forKey: withKey) as? Data else { return nil }
        return try JSONDecoder().decode(T.self, from: loadedData)
    }
}
