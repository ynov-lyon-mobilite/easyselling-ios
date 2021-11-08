//
//  MyVehiclesViewModel.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 25/10/2021.
//

import Foundation
import UIKit

class MyVehiclesViewModel: ObservableObject {
    
    init(requestGenerator: RequestGenerator = DefaultRequestGenerator(),
         apiCaller: APICaller = DefaultAPICaller(),
         isOpenningVehicleCreation: @escaping Action) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
        self.isOpenningVehicleCreation = isOpenningVehicleCreation
    }
    
    private var requestGenerator: RequestGenerator
    private var apiCaller: APICaller
    private var isOpenningVehicleCreation: Action
    @Published var isLoading: Bool = true
    @Published var vehicles: [Vehicle] = []
    @Published var alert: APICallerError?
    @Published var isError: Bool = false
 
    func openVehicleCreation() {
        self.isOpenningVehicleCreation()
    }
    
    @MainActor func getVehicles() async {
        let request: URLRequest
        
        do {
            request = try requestGenerator.generateRequest(endpoint: .vehicles, method: .GET, headers: [:])
            vehicles = try await apiCaller.call(request, decodeType: [Vehicle].self)
        } catch (let error) {
            if let error = error as? APICallerError {
                isError = true
                self.alert = error
            } else {
                self.alert = nil
            }
        }
        
        isLoading = false
    }
}
