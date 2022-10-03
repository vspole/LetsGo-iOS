//
//  YelpNetworkingService.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//

import Foundation
import Alamofire

protocol YelpNetworkingServiceProtocol: AnyObject {
    func fetchBusinesses(type: String, latitude: String, longitude: String,  completion: @escaping (DataResponse<BusinessSearchReturnModel,AFError>) -> Void)
}

class YelpNetworkingService: DependencyContainer.Component, YelpNetworkingServiceProtocol {
    func fetchBusinesses(type: String, latitude: String, longitude: String, completion: @escaping (DataResponse<BusinessSearchReturnModel, AFError>) -> Void) {
        let headers: HTTPHeaders = [
                    "Authorization": "Bearer XELlE4CiSxD1YWKKSM03sQv2LkFpm_NNcKMRyf4VDMW6xmmuyP4yu_DoAh7vh2lrI81uEQDp_thm3-LfP4MMFIMl87QWLSJ4-JP3jjGtMx9in-eD6oBb1_ffJhg6Y3Yx"]
        let request = AF.request(String(format: Endpoint.searchWithLocation, type, latitude, longitude), headers: headers)

        request.responseDecodable(of: BusinessSearchReturnModel.self) { (response) in
            completion(response)
        }
    }
}

