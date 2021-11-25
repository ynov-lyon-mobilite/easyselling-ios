//
//  DefaultVehicleDeletor.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 18/11/2021.
//

import Foundation

protocol VehicleDeletor {
    func deleteVehicle(id: String) async throws
}

class DefaultVehicleDeletor: VehicleDeletor {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func deleteVehicle(id: String) async throws {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .deleteVehicle, method: .DELETE, headers: [:])
        try await apiCaller.call(urlRequest)
    }
}
