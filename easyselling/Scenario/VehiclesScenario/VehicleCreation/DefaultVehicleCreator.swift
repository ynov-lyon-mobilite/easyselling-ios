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
    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller
    
    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }
    
    func createVehicle(informations: Vehicle) async throws {
        let urlRequest = try requestGenerator.generateRequest(endpoint: .vehicles, method: .POST, body: informations, headers: [:])
        try await apiCaller.call(urlRequest)
    }
}
