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
    
    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }
    
    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller
    
    func deleteVehicle(id: String) async throws {
        let urlRequest = try requestGenerator.generateRequest(endpoint: .deleteVehicle, method: .DELETE, headers: [:])
        /*print("REQUETE")
        print(id)
        print(urlRequest)*/
        try await apiCaller.call(urlRequest)
    }
}
