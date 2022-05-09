//
//  DefaultVehicleBrandGetter.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 20/04/2022.
//

import Foundation

protocol VehicleBrandGetter {
    func getVehicleBrand() async throws -> [Brand]
}

class DefaultVehicleBrandGetter : VehicleBrandGetter {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func getVehicleBrand() async throws -> [Brand] {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .vehicleBrands, method: .GET, headers: [:],
                                                                    pathKeysValues: [:], queryParameters: nil)

        return try await apiCaller.call(urlRequest, decodeType: [Brand].self)
    }
}
