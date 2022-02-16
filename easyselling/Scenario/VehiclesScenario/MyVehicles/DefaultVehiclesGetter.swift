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

            let vehiclesDTO = try await apiCaller.call(urlRequest, decodeType: [Vehicle].self)

            mainContext.performAndWait {
                for vehicle in vehiclesDTO {
                    let vehicleInCoreData = VehicleCoreData.fetchRequestById(id: vehicle.id ?? "")

                    if vehicleInCoreData == nil {
                        _ = Vehicle.toCoreDataObject(vehicle: vehicle)
                        if mainContext.hasChanges {
                            try? mainContext.save()
                        }
                    }
                }
            }

            let vehiclesCoreData = try mainContext.fetch(VehicleCoreData.fetchRequest())
            var vehicles: [Vehicle] = []

            vehiclesCoreData.forEach { vehicle in
                vehicles.append(Vehicle(brand: vehicle.brand, id: vehicle.id, license: vehicle.license, model: vehicle.model, type: Vehicle.Category(rawValue: vehicle.type) ?? .car, year: vehicle.year))
            }

            return vehicles
        } catch (_) {
            throw APICallerError.internalServerError
        }
    }
}
