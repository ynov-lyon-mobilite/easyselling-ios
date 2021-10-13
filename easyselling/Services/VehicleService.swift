//
//  VehicleService.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

class VehicleService {
    private var httpCode: Int
    
    init(httpCode: Int) {
        self.httpCode = httpCode
    }
    
    func createNewVehicle(vehicle: Vehicle, callBack: @escaping (_ succes: Bool,_ message: String) -> Void) {
        // TODO: Do the right api call
        guard checkingInformations(vehicle: vehicle) else { return
            callBack(false, "Informations invalids")
        }
        
        switch(httpCode) {
        case 200:
            // TODO: Back to the vehicles list in the callback
            callBack(true, HTTPMessage.responseMessages[httpCode] ?? "")
        default:
            // TODO: Display a popup in the callback
            callBack(false, HTTPMessage.responseMessages[httpCode] ?? "")
        }
    }
    
    func checkingInformations(vehicle: Vehicle) -> Bool {
        guard vehicle.immatriculation.count == 8,
              vehicle.licenceNumber.count == 14,
              vehicle.age < 100 else {
            return false
        }
        return true
    }
}
