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
    
    func call<T>(_ urlRequest: URLRequest, decodeType: T.Type) -> DecodedResult<T> where T : Decodable {
        AnyPublisher(Fail(error: HTTPError.from(statusCode: error)))
    }
    
    func call(_ urlRequest: URLRequest) -> VoidResult {
        AnyPublisher(Fail(error: HTTPError.from(statusCode: error)))
    }
}
