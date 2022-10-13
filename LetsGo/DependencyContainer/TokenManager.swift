//
//  TokenManager.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/12/22.
//

import Foundation


public protocol TokenManagerProtocol {
    func storeToken(token: String)
    func retrieveToken() -> String
}

public let accessTokenKey = "user.access.token"

public class TokenManager<Entity: EntityProtocol>: TokenManagerProtocol, ComponentProtocol {
    public unowned var entity: Entity
    private var localStorageManager: LocalStorageManagerProtocol { getEntityComponent() }
    
    public init(entity: Entity) {
        self.entity = entity
    }
    
    
    public func storeToken(token: String) {
        localStorageManager.securelyStore(key: accessTokenKey, data: token)
    }

    public func retrieveToken() -> String {
        localStorageManager.securelyRetrieveData(key: accessTokenKey) ?? ""
    }
}
