//
//  DefaultVehicleDeletor.swift
//  easyselling
//
//  Created by Lucas Barthélémy on 18/11/2021.
//

import Foundation
import CoreData

protocol VehicleDeletor {
    func deleteVehicle(id: String) async throws
}

class DefaultVehicleDeletor: VehicleDeletor {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(),
         apiCaller: APICaller = DefaultAPICaller(),
         context: NSManagedObjectContext) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
        self.context = context
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller
    private var context: NSManagedObjectContext

    func deleteVehicle(id: String) async throws {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .vehicleId,
                                                                    method: .DELETE,
                                                                    headers: [:],
                                                                    pathKeysValues: ["vehicleId" : id],
                                                                    queryParameters: nil)

        try await apiCaller.call(urlRequest)

        try context.performAndWait {
            if let vehicle = VehicleCoreData.fetchRequestById(id: id) {
                context.delete(vehicle)
                if context.hasChanges {
                    try context.save()
                }
            }
        }
    }
}
