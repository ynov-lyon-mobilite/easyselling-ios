//
//  DefaultVehicleShare.swift
//  easyselling
//
//  Created by Théo Tanchoux on 09/03/2022.
//

import Foundation

protocol VehicleShare {
    func shareVehicle(id: String, email: String) async throws
}

class DefaultVehicleShare : VehicleShare {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func shareVehicle(id: String, email: String) async throws {
        let dto = ShareDTO(email: email)
        let urlRequest = try await requestGenerator
            .generateRequest(endpoint: .shareVehicle, method: .POST, body: dto,
                             headers: [:], pathKeysValues: ["vehicleId": id], queryParameters: nil)
        try await apiCaller.call(urlRequest)
    }

    func activateVehicle(id: String) async throws {
        let urlRequest = try await requestGenerator
            .generateRequest(endpoint: .activateVehicle, method: .POST,
                             headers: [:], pathKeysValues: ["activationId": id], queryParameters: nil)
        try await apiCaller.call(urlRequest)
    }
}
