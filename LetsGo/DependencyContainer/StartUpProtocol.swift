//
//  StartUpProtocol.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/12/22.
//

import Foundation

/// A priority for invoking the `startUp` methods of components in an entity container where a higher priority indicates earlier invocation
public enum StartUpPriority: Comparable {
    case low
    case medium
    case high
}

/// A protocol that indicates something requires setup after initialization.  When used on a Component of the DependencyContainer, startUp will occur in AppDelegate's didFinishLaunchingWithOptions.
public protocol StartUpProtocol {
    var priority: StartUpPriority { get }
    
    func startUp()
}

public extension StartUpProtocol {
    var priority: StartUpPriority { .medium }
}

public extension EntityProtocol {
    func startUp() {
        components
            .compactMap { $0 as? StartUpProtocol }
            .sorted { $0.priority > $1.priority }
            .forEach { $0.startUp() }
    }
}
