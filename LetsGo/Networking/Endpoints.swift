//
//  Endpoints.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//

import Foundation

enum Endpoint {
    private static let base = "https://api.yelp.com/v3"

    static let businesses = "\(base)/businesses"
    static let search = "\(businesses)/search?term=%@" // %@ = cat ID
    static let searchWithLocation = "\(search)&latitude=%@&longitude=%@"
}
