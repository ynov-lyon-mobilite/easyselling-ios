//
//  VehicleService.swift
//  easyselling
//
//  Created by Valentin Mont School on 13/10/2021.
//

class VehicleService {
    private var httpCode: Int
    private var vehicle: Vehicle?
    
    init(httpCode: Int, vehicle: Vehicle? = nil) {
        self.httpCode = httpCode
        self.vehicle = vehicle
    }
    
    func createNewVehicle(callBack: @escaping (_ succes: Bool,_ message: String) -> Void) {
        // TODO: Do the right api call
        switch(httpCode) {
        case 200:
            // TODO: Back to the vehicles list in the callback
            callBack(true, HTTPMessage.responseMessages[httpCode] ?? "")
        default:
            // TODO: Display a popup in the callback
            callBack(false, HTTPMessage.responseMessages[httpCode] ?? "")
        }
    }
    
    func checkingInformations(callBack: @escaping (_ succes: Bool) -> Void) {
        guard let vehicle = vehicle,
                vehicle.immatriculation.count == 8,
                vehicle.licenceNumber.count == 14,
                vehicle.age < 100 else {
            callBack(false)
            return
        }
        callBack(true)
    }
}
