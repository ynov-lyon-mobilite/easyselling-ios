//
//  MyVehiclesViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import Foundation

class MyVehiclesViewModel {
    
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
    var loading: Bool = true
    var vehicles: [Vehicle] = []
 
    func openVehicleCreation() {
        self.isOpenningVehicleCreation()
    }
    
    func getVehicles() async {
        // call api
        let request: URLRequest
        
        do {
            request = try requestGenerator.generateRequest(endpoint: .vehicles, method: .GET, headers: [:])
            vehicles = try await apiCaller.call(request, decodeType: [Vehicle].self)
        } catch {}
        
        // fin du call
        loading = false
    }
}

struct Vehicle: Equatable, Decodable {
    var brand: String
}
