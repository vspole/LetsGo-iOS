//
//  VersionProvider.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/30/22.
//

import UIKit

public protocol VersionProviderProtocol {
    var iOSVersion: String { get }
    var deviceModel: String { get }
    var appVersion: String? { get }
    var shortAppVersion: String? { get }
}

public class VersionProvider: VersionProviderProtocol {
    public var iOSVersion: String {
        "iOS \(UIDevice.current.systemVersion)"
    }

    public var deviceModel: String {
        UIDevice.modelName
    }

    public var appVersion: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }

    public var shortAppVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    public init() {}
}
