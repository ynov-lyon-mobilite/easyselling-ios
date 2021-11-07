//
//  MyVehiclesViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import Foundation
import UIKit

class MyVehiclesViewModel: ObservableObject {
    
    init(isOpenningVehicleCreation: @escaping Action,
         requestGenerator: RequestGenerator = DefaultRequestGenerator(),
         urlSession: URLSessionProtocol = URLSession.shared) {
        self.isOpenningVehicleCreation = isOpenningVehicleCreation
        self.requestGenerator = requestGenerator
        self.urlSession = urlSession
        self.apiCaller = DefaultAPICaller(urlSession: urlSession)
    }
    
    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller
    private var urlSession: URLSessionProtocol
    private var isOpenningVehicleCreation: Action
    @Published var isLoading: Bool = true
    @Published var vehicles: [Vehicle] = []
    @Published var error: APICallerError?
    @Published var isError: Bool = false
 
    func openVehicleCreation() {
        self.isOpenningVehicleCreation()
    }
    
    @MainActor func getVehicles() async {
        // call api
        let request: URLRequest
        
        do {
            request = try requestGenerator.generateRequest(endpoint: .vehicles, method: .GET, headers: [:])
            vehicles = try await apiCaller.call(request, decodeType: [Vehicle].self)
        } catch (let error) {
            if let error = error as? APICallerError {
                isError = true
                self.error = error
            } else {
                self.error = nil
            }
        }
        
        // fin du call
        isLoading = false
    }
}

struct Vehicle: Equatable, Decodable, Identifiable {
    var id: String
    var brand: String
    var model: String
    var license: String
    var type: VehicleTypeEnum
    var year: String
    
}

enum VehicleTypeEnum: String, Decodable {
    case car, moto
    
    var description: String {
        switch self {
        case .car:
            return L10n.Vehicles.car
        case .moto:
            return L10n.Vehicles.moto
        }
    }

}
