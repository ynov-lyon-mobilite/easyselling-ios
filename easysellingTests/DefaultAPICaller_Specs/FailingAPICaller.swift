//
//  FailingAPICaller.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 16/10/2021.
//

import Foundation
import Combine
@testable import easyselling

class FailingAPICaller: APICaller {
    
    init(withError error: Int) {
        self.error = error
    }
    
    private var error: Int
    
    func call<T: Decodable>(_ urlRequest: URLRequest, decodeType: T.Type) async throws -> T {
        throw APICallerError.from(statusCode: error)
    }
    
    func call(_ urlRequest: URLRequest) async throws {
        throw APICallerError.from(statusCode: error)
    }
}
