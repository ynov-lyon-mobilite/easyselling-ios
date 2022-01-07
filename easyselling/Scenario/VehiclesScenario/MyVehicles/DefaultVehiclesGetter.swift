//
//  DefaultVehiclesGetter.swift
//  easyselling
//
//  Created by Théo Tanchoux on 11/11/2021.
//

import Foundation

protocol VehiclesGetter {
    func getVehicles() async throws -> [Vehicle]
}

class DefaultVehiclesGetter : VehiclesGetter {

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    func getVehicles() async throws -> [Vehicle] {
//        let queryParameters: [QueryParameter] = [
//            SortQueryParameter(propertyName: "year", type: .DESC),
//            FilterQueryParameter(parameterName: "model", value: "206")
//        ]

        let urlRequest = try await requestGenerator.generateRequest(endpoint: .vehicles, method: .GET, headers: [:],
                                                                    pathKeysValues: [:], queryParameters: [])

        do {
            let _: [VehicleDTO] = try await apiCaller.call(urlRequest, decodeType: [VehicleDTO].self)
        } catch (let error) {
            throw error
        }

        return [Vehicle()]
    }
}
