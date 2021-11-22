//
//  VehicleCreator.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

import Foundation
import Combine

protocol VehicleCreatorProtocol {
    func createVehicle(informations: VehicleInformations) async throws
}

class VehicleCreator: VehicleCreatorProtocol {
    private var requestGenerator: DefaultRequestGenerator
    private var apiCaller: DefaultAPICaller

    init(requestGenerator: DefaultRequestGenerator = DefaultRequestGenerator(), apiCaller: DefaultAPICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    func createVehicle(informations: VehicleInformations) async throws {
        let urlRequest = try requestGenerator.generateRequest(endpoint: .vehicles, method: .POST, body: informations, headers: [:])
        try await apiCaller.call(urlRequest)
    }
}
