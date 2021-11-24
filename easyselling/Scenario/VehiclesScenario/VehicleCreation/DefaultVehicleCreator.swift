//
//  VehicleCreator.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

import Foundation
import Combine

protocol VehicleCreator {
    func createVehicle(informations: Vehicle) async throws
}

class DefaultVehicleCreator: VehicleCreator {
    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    func createVehicle(informations: Vehicle) async throws {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .vehicles, method: .POST, body: informations)
        try await apiCaller.call(urlRequest)
    }
}
