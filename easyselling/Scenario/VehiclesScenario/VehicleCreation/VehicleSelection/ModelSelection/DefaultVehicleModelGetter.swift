//
//  DefaultVehicleModelGetter.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 20/04/2022.
//

import Foundation

protocol VehicleModelGetter {
    func getVehicleModel() async throws -> [Model]
}

class DefaultVehicleModelGetter : VehicleModelGetter {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func getVehicleModel() async throws -> [Model] {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .vehicleModels, method: .GET, headers: [:],
                                                                    pathKeysValues: [:], queryParameters: nil)

        return try await apiCaller.call(urlRequest, decodeType: [Model].self)
    }
}
