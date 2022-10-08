//
//  CategoryModel.swift
//  LetsGo
//
//  Created by Devin Dupree on 10/4/22.
//

import Foundation

struct CategoryModel: Codable, Hashable {
    let title: String

    enum CodingKeys: String, CodingKey {
        case title
      
    }
}
