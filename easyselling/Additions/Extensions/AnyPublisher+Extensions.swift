//
//  AnyPublisher+Extensions.swift
//  easyselling
//
//  Created by Maxence on 15/10/2021.
//

import Combine

extension AnyPublisher {
    static var empty: AnyPublisher {
        return AnyPublisher(Empty())
    }
}
