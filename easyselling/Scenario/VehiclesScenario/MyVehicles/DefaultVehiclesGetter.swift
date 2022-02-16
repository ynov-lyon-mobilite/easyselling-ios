//
//  DefaultVehiclesGetter.swift
//  easyselling
//
//  Created by Théo Tanchoux on 11/11/2021.
//

import Foundation

protocol VehiclesGetter {
    func getVehicles() async throws -> [VehicleCoreData]
}

class DefaultVehiclesGetter : VehiclesGetter {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func getVehicles() async throws -> [VehicleCoreData] {
        do {
            let urlRequest = try await requestGenerator.generateRequest(endpoint: .vehicles, method: .GET, headers: [:],
                                                                               pathKeysValues: [:], queryParameters: [])

            let vehicles = try await apiCaller.call(urlRequest, decodeType: [VehicleResponse].self)

            mainContext.performAndWait {
                for vehicle in vehicles {
                    let vehicleInCoreData = VehicleCoreData.fetchRequestById(id: vehicle.id)

                    if vehicleInCoreData == nil {
                        _ = Vehicle.toCoreDataObject(vehicle: vehicle)
                        if mainContext.hasChanges {
                            try? mainContext.save()
                        }
                    }
                }
            }
            return try mainContext.fetch(VehicleCoreData.fetchRequest())
        } catch (_) {
            let vehiclesCoreData = try? mainContext.fetch(VehicleCoreData.fetchRequest())
            var vehicles: [Vehicle] = []

            vehiclesCoreData?.forEach { vehicle in
                vehicles.append(Vehicle.fromCoreDataToObject(vehicle: vehicle))
            }

            return vehicles
        }
    }
}
