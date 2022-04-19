//
//  DefaultVehicleGetter.swift
//  easyselling
//
//  Created by Théo Tanchoux on 09/03/2022.
//

import Foundation

protocol SharedVehiclesGetter {
    func getSharedVehicles() async throws -> [Vehicle]
}

class DefaultSharedVehiclesGetter : SharedVehiclesGetter {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(),
         apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func getSharedVehicles() async throws -> [Vehicle] {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .sharedVehicles,
                                                                    method: .GET,
                                                                    headers: [:],
                                                                    pathKeysValues: [:],
                                                                    queryParameters: [:])
        return try await apiCaller.call(urlRequest, decodeType: [Vehicle].self)
    }
}
