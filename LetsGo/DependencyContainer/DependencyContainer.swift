//
//  DependencyContainer.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//


import Foundation

class DependencyContainer: ObservableObject, EntityProtocol {
    var components: [AnyObject] = []

}

extension DependencyContainer {
    class Component {
        unowned var entity: DependencyContainer

        init(entity: DependencyContainer) {
            self.entity = entity
        }
    }

    static func create() -> DependencyContainer {
        let container = DependencyContainer()
        container.components = [
            YelpNetworkingService(entity: container),
            LocationService(entity: container),
            FirebaseAuthService(entity: container),
            LocalStorageManager()
        ]
        return container
    }
}

// MARK: - Convenience property wrappers

extension DependencyContainer {
    var yelpNetworkingService: YelpNetworkingServiceProtocol { getComponent() }
    var locationService: LocationServiceProtocol { getComponent() }
    var firebaseAuthService: FirebaseAuthServiceProtocol { getComponent() }
    var localStorageManager: LocalStorageManagerProtocol { getComponent() }
}

