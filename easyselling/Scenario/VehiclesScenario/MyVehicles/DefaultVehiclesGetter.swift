//
//  DefaultVehiclesGetter.swift
//  easyselling
//
//  Created by Théo Tanchoux on 11/11/2021.
//

import Foundation
import CoreData

protocol VehiclesGetter {
    func getVehicles() async throws -> [Vehicle]
}

class DefaultVehiclesGetter : VehiclesGetter {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(),
         apiCaller: APICaller = DefaultAPICaller(),
         context: NSManagedObjectContext = mainContext) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
        self.context = context
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller
    private var context: NSManagedObjectContext

    func getVehicles() async throws -> [Vehicle] {
    do {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .vehicles, method: .GET, headers: [:],
                                                                   pathKeysValues: [:], queryParameters: [:])

        let vehicles = try await apiCaller.call(urlRequest, decodeType: [Vehicle].self)

        context.performAndWait {
           for vehicle in vehicles {
               let vehicleInCoreData = VehicleCoreData.fetchRequestById(id: vehicle.id)

               if vehicleInCoreData == nil {
                   _ = Vehicle.toCoreDataObject(vehicle: vehicle, in: context)
                   if context.hasChanges {
                       try? context.save()
                   }
               }
           }
        }

        return vehicles
       } catch {
           var vehicles: [Vehicle] = []
           do {
               let vehiclesCoreData = try context.fetch(VehicleCoreData.fetchRequest())
               vehiclesCoreData.forEach { vehicle in
                   vehicles.append(Vehicle.toVehicle(vehicle: vehicle))
               }
           } catch {
               throw APICallerError.unknownError
           }
           return vehicles
       }
   }
}
