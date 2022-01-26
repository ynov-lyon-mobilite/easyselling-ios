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

    func getInvoices(ofVehicleId id: String) async throws -> [Invoice] {
        do {
            return try mainContext.fetch(Invoice.fetchRequest())
        }
    }
}
