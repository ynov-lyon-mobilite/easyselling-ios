//
//  VehicleCreator.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

import Foundation

protocol VehicleCreator {
    func createVehicle(informations: VehicleDTO) async throws
}

class DefaultVehicleCreator: VehicleCreator {
    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    func createVehicle(informations: VehicleDTO) async throws {
        let urlRequest = try await requestGenerator
            .generateRequest(endpoint: .vehicles, method: .POST, body: informations,
                             headers: [:], pathKeysValues: [:], queryParameters: nil)
        do {
            try await apiCaller.call(urlRequest)
            
        } catch (let error) {
            throw error
        }
    }
}
