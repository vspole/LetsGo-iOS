//
//  ConfigNetworkingService.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/30/22.
//

import Foundation

import Foundation
import Alamofire

protocol ConfigNetworkingServiceProtocol: AnyObject {
    func fetchConfig(completion: @escaping (DataResponse<ConfigReturnModel,AFError>) -> Void)
}

class ConfigNetworkingService: DependencyContainer.Component, ConfigNetworkingServiceProtocol {
    func fetchConfig(completion: @escaping (DataResponse<ConfigReturnModel, AFError>) -> Void) {
        let request = AF.request(Endpoint.config)

        request.responseDecodable(of: ConfigReturnModel.self) { (response) in
            completion(response)
        }
    }
}
