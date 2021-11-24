//
//  DefaultVehiclesGetter.swift
//  easyselling
//
//  Created by Théo Tanchoux on 11/11/2021.
//

import Foundation

protocol VehiclesGetter {
    func getVehicles() async throws -> [Vehicle]
}

class DefaultVehiclesGetter : VehiclesGetter {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func getVehicles() async throws -> [Vehicle] {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .vehicles, method: .GET, headers: [:], pathKeysValues: [:])
        return try await apiCaller.call(urlRequest, decodeType: [Vehicle].self)
    }
}
