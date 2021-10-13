//
//  VehicleService.swift
//  easyselling
//
//  Created by Théo Tanchoux on 13/10/2021.
//

import Foundation

class VehicleService {
    
    @Published var vehicules = [Vehicle]()
    
    func getMockVehicles(token: String, completion:@escaping ([Vehicle]) -> (), name: String = "mockData") {
        guard let serverResponse = self.readLocalFile(forName: name) else { return }
        
        self.vehicules = self.parseVehicles(json: serverResponse)
        completion(vehicules)
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parseVehicles(json: Data) -> [Vehicle] {
        let decoder = JSONDecoder()

        do {
            return try decoder.decode(Vehicles.self, from: json).data
        } catch(let error) {
            print(error)
            return []
        }
    }
}
