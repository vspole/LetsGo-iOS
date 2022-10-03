//
//  BusinessSearchReturnModel.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//

import Foundation

struct BusinessSearchReturnModel: Decodable, Hashable {
    let businesses: [BusinessModel]
    let total: Int

    enum CodingKeys: String, CodingKey {
        case businesses = "businesses"
        case total = "total"
    }
}
