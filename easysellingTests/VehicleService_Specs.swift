//
//  VehicleService.swift
//  easysellingTests
//
//  Created by Théo Tanchoux on 13/10/2021.
//

import Foundation
import XCTest
@testable import easyselling

class VehicleService_Specs: XCTestCase {
    
    func test_get_users_from_back() {
        let users = getMockUsers(token: "dzbsudqkghhgcvdsbv")
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users[0].id, "0bba811a-e7c4-4699-a22b-eafed317bf94")
        XCTAssertEqual(users[1].id, "c3f462e8-891e-46c4-8590-c4ad1d348421")
    }
    
    func test_invalid_file_name() {
        let users = getMockUsers(token: "dzbsudqkghhgcvdsbv", name: "invalidFileName")
        XCTAssertEqual(users.count, 0)
    }
    
    private func getMockUsers(token: String, name: String = "mockData") -> [Vehicle] {
        guard let serverResponse = self.readLocalFile(forName: name) else { return [] }
        
        return self.parseVehicles(json: serverResponse)
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
