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
    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller
    
    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }
    
    func deleteVehicle(id: String) async throws {
        let urlRequest = try requestGenerator.generateRequest(endpoint: .updateVehicle, method: .DELETE, headers: [:])
        print("REQUETE")
        print(id)
        print(urlRequest)
        try await apiCaller.call(urlRequest)
    }
}
