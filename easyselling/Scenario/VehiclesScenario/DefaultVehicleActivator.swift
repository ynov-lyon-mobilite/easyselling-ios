//
//  DefaultVehicleActivator.swift
//  easyselling
//
//  Created by Théo Tanchoux on 30/03/2022.
//

import Foundation

protocol VehicleActivator {
    func activateVehicle(id: String) async throws
}

class DefaultVehicleActivator : VehicleActivator {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func activateVehicle(id: String) async throws {
        let urlRequest = try await requestGenerator
            .generateRequest(endpoint: .activateVehicle, method: .POST,
                             headers: [:], pathKeysValues: ["authorizationId": id], queryParameters: nil)
        try await apiCaller.call(urlRequest)
    }
}
