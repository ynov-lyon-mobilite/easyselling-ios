//
//  AnyPublisher+Extensions.swift
//  easyselling
//
//  Created by Maxence on 15/10/2021.
//

import Combine

extension AnyPublisher {
    static var empty: AnyPublisher {
        AnyPublisher(Empty())
    }
    
    static func error<Output, Failure: Error>(_ error: Failure) -> AnyPublisher<Output, Failure> {
        AnyPublisher<Output, Failure>(Fail(error: error))
    }
}
