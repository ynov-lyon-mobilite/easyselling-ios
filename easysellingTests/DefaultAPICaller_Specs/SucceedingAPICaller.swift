//
//  SucceedingAPICaller.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 16/10/2021.
//

import Foundation
import Combine
@testable import easyselling

class SucceedingAPICaller: APICaller {
    
    func call<T>(_ urlRequest: URLRequest, decodeType: T.Type) -> DecodedResult<T> where T : Decodable {
        return Just("" as! T)
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
    
    func call(_ urlRequest: URLRequest) -> VoidResult {
        return Just(())
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
}
