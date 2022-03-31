//
//  DefaultVehicleGetter.swift
//  easyselling
//
//  Created by Théo Tanchoux on 09/03/2022.
//

import Foundation

protocol VehicleGetter {
    func getVehicle(id: String) async throws -> Vehicle
}

class DefaultVehicleGetter : VehicleGetter {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func getVehicle(id: String) async throws -> Vehicle {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .vehicleId, method: .GET, headers: [:],
                                                                    pathKeysValues: ["vehicleId": id], queryParameters: [:])
        return try await apiCaller.call(urlRequest, decodeType: Vehicle.self)
    }
}
