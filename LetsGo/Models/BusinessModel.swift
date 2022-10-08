//
//  BusinessModel.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//

import Foundation

struct BusinessModel: Hashable, Identifiable, Codable {
    let id: String
    let name: String
    let imageURLString: String
    let review_count: Int
    let rating: Double
    let categories: [CategoryModel]
    
    var imageURL: URL? {
        URL(string: imageURLString)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURLString = "image_url"
        case review_count
        case rating
        case categories
    }
}



