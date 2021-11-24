//
//  DefaultVehicleUpdater.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 24/11/2021.
//

import Foundation

protocol VehicleUpdater {
    func updateVehicle(informations: Vehicle) async throws
}

class DefaultVehicleUpdater: VehicleUpdater {
    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    func updateVehicle(informations: Vehicle) async throws {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .vehicles, method: .PATCH, body: informations, headers: [:])
        try await apiCaller.call(urlRequest)
    }
}
