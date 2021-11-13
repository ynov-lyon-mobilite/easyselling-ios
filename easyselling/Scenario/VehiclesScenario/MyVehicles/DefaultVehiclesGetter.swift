//
//  DefaultVehiclesGetter.swift
//  easyselling
//
//  Created by Théo Tanchoux on 11/11/2021.
//

import Foundation

protocol VehiclesGetter {
    func getVehicles() async throws -> [VehicleInformations]
}

class DefaultVehiclesGetter : VehiclesGetter {
    
    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }
    
    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller
    
    func getVehicles() async throws -> [VehicleInformations] {
        let urlRequest = try requestGenerator.generateRequest(endpoint: .vehicles, method: .GET, headers: [:])
        return try await apiCaller.call(urlRequest, decodeType: [VehicleInformations].self)
    }
}
