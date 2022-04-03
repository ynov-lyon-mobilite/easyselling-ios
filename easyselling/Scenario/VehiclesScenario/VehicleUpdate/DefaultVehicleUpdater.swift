//
//  DefaultVehicleUpdater.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 24/11/2021.
//

import Foundation
import CoreData

protocol VehicleUpdater {
    func updateVehicle(informations: Vehicle) async throws
}

class DefaultVehicleUpdater: VehicleUpdater {

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller
    private var context: NSManagedObjectContext

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(),
         apiCaller: APICaller = DefaultAPICaller(),
         context: NSManagedObjectContext) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
        self.context = context
    }

    func updateVehicle(informations: Vehicle) async throws {
        let urlRequest = try await requestGenerator
            .generateRequest(endpoint: .vehicleId, method: .PATCH, body: informations.toDTO(), headers: [:],
                             pathKeysValues: ["vehicleId": informations.id], queryParameters: nil)

        try await apiCaller.call(urlRequest)

        try context.performAndWait {
            let vehicleInCoreData = VehicleCoreData.fetchRequestById(id: informations.id)
            vehicleInCoreData?.update(withVehicle: informations)
            if context.hasChanges {
                try context.save()
            }
        }
    }
}
