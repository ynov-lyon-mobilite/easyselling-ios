//
//  SuccedingVehicleGetterWithDelete.swift
//  easysellingTests
//
//  Created by Lucas Barthélémy on 24/11/2021.
//

import Foundation
@testable import easyselling

class SucceedingVehiclesGetterWithDelete: VehiclesGetter {

    init(_ vehicles: [Vehicle], id: String) {
        self.vehicles = vehicles
        self.id = id
    }

    private var vehicles: [Vehicle]
    private var id: String

    func getVehicles() async throws -> [Vehicle] {
        deleteVehicle(id: self.id)
        return vehicles
    }

    private func deleteVehicle(id: String) {
          var index = 0
          for vehicle in vehicles {
              if vehicle.id == id {
                  self.vehicles.remove(at: index)
                  break
              } else {
                  index += 1
              }
          }
    }
}
