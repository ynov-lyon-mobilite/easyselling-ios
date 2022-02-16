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
        do {
            let urlRequest = try await requestGenerator.generateRequest(endpoint: .vehicles, method: .GET, headers: [:],
                                                                               pathKeysValues: [:], queryParameters: [])

            let vehicles = try await apiCaller.call(urlRequest, decodeType: [VehicleDTO].self)

            mainContext.performAndWait {
                for vehicle in vehicles {
                    let vehicleInCoreData = Vehicle.fetchRequestById(id: vehicle.id ?? "")

                    if vehicleInCoreData == nil {
                        let entity = Vehicle(context: mainContext)
                        entity.id = vehicle.id
                        entity.license = vehicle.license
                        entity.brand = vehicle.brand
                        entity.year = vehicle.year
                        entity.type = vehicle.type.rawValue
                        entity.model = vehicle.model

                        if mainContext.hasChanges {
                            try? mainContext.save()
                        }
                    }
                }
            }
            return try mainContext.fetch(Vehicle.fetchRequest())
        } catch (_) {
            throw APICallerError.internalServerError
        }
    }
}
