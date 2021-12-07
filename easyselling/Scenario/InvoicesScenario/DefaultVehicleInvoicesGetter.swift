//
//  DefaultVehicleInvoicesGetter.swift
//  easyselling
//
//  Created by Corentin Laurencine on 24/11/2021.
//

import Foundation

protocol VehicleInvoicesGetter {
    func getInvoices(ofVehicleId: String) async throws -> [Invoice]
}

class DefaultVehicleInvoicesGetter : VehicleInvoicesGetter {
    private var requestGenerator: AuthorizedRequestGenerator
    private var apiCaller: APICaller

    init(requestGenerator: AuthorizedRequestGenerator = DefaultAuthorizedRequestGenerator(), apiCaller: APICaller = DefaultAPICaller()) {
        self.requestGenerator = requestGenerator
        self.apiCaller = apiCaller
    }

    func getInvoices(ofVehicleId: String) async throws -> [Invoice] {
        let urlRequest = try await requestGenerator.generateRequest(endpoint: .invoices, method: .GET, headers: [:], pathKeysValues: [:], queryParameters: [])
        return try await apiCaller.call(urlRequest, decodeType: [Invoice].self)
    }
}
