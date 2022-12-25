//
//  ConfigReturnModel.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/30/22.
//

import Foundation

struct ConfigReturnModel: Decodable, Hashable {
    let minSupportedVersion: String

    enum CodingKeys: String, CodingKey {
        case minSupportedVersion = "minSupportedVersion"
    }
}
