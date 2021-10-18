//
//  VehicleCreator.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

import Foundation
import Combine

protocol VehicleCreatorProtocol {
    func createVehicle(informations: VehicleInformations) -> VoidResult
}

class VehicleCreator: VehicleCreatorProtocol {
    private var requestGenerator: DefaultRequestGenerator
    private var apiCaller: NetworkService
    
    init(requestGenerator: DefaultRequestGenerator = DefaultRequestGenerator(), apiCaller: NetworkService = NetworkService()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }
    
    func createVehicle(informations: VehicleInformations) -> VoidResult {
        let urlRequest = requestGenerator.generateRequest(endpoint: "https://easyselling.maxencemottard.com/items/vehicles", method: .POST, body: informations, headers: [:])
        guard let urlRequest = urlRequest else {
            return AnyPublisher(Empty())
        }
        return apiCaller.call(urlRequest)
    }
}
