//
//  EntityProtocol .swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//

import Foundation

public protocol EntityProtocol: AnyObject {
    var components: [AnyObject] { get set }

    func getComponent<T>() -> T
}

extension EntityProtocol {
    func getComponent<T>() -> T {
        guard let component: T = getOptionalComponent() else {
            fatalError("Expected component type: \(T.self)")
        }
        return component
    }

    func getOptionalComponent<T>() -> T? {
        components.compactMap{ $0 as? T }.first
    }
}
