//
//  Endpoints.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//

import Foundation

enum Endpoint {
    private static let apiBase = "https://letsgo-69e94-g3jtiptnpq-uc.a.run.app"
    static let config = "\(apiBase)/checkMinVersion"

    private static let yelpBase = "https://api.yelp.com/v3"
    static let businesses = "\(yelpBase)/businesses"
    static let search = "\(businesses)/search?term=%@" // %@ = cat ID
    static let searchWithLocation = "\(search)&latitude=%@&longitude=%@"
}
