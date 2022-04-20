//
//  VehicleCreator.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

import Foundation
import CoreData

protocol VehicleCreator {
    func createVehicle(informations: VehicleDTO) async throws
}

class DefaultVehicleCreator: VehicleCreator {
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

    func createVehicle(informations: VehicleDTO) async throws {
        let urlRequest = try await requestGenerator
            .generateRequest(endpoint: .vehicles, method: .POST, body: informations,
                             headers: [:], pathKeysValues: [:], queryParameters: nil)

        let vehicle = try await apiCaller.call(urlRequest, decodeType: Vehicle.self)

        try context.performAndWait {
            _ = vehicle.toCoreDataObject(in: context)
            if context.hasChanges {
                try context.save()
            }
        }
    }
}
