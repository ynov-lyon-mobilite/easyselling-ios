//
//  MyVehicleTask.swift
//  easyselling
//
//  Created by Valentin Mont School on 26/01/2022.
//

import Foundation

class MyVehicleTask: DefaultAPICaller, TaskAPI {

    func generateRequest() async -> URLRequest? {
        let request: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator()
        let urlRequest = try? await request.generateRequest(endpoint: .vehicles, method: .GET, headers: [:], pathKeysValues: [:], queryParameters: [])

        return urlRequest
    }

    func parseJSONToCoreDataObject() async {
        guard let request = await self.generateRequest() else { return }

        do {
            let vehicles = try await self.call(request, decodeType: [VehicleResponse].self)

            for vehicle in vehicles {
                persistentContainer.viewContext.performAndWait {
                    let entity = Vehicle(context: persistentContainer.viewContext)
                    entity.id = vehicle.id
                    entity.license = vehicle.license
                    entity.brand = vehicle.brand
                    entity.year = vehicle.year
                    entity.type = vehicle.type
                    entity.model = vehicle.model

                    if persistentContainer.viewContext.hasChanges {
                        try? persistentContainer.viewContext.save()
                    }


                    print(try? persistentContainer.viewContext.fetch(Vehicle.fetchRequest()))
                }
            }
        } catch (let error) {
            print(error)
        }
    }
}

struct VehicleResponse: Codable {
    var id: String?
    var brand: String
    var model: String
    var license: String
    var type: String
    var year: String
}
