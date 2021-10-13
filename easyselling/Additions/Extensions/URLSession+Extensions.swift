//
//  URLSession+Extensions.swift
//  easyselling
//
//  Created by Maxence on 13/10/2021.
//

import Foundation

extension URLSession: UrlSessionProtocol {
    func dataTaskAnyPublisher(for request: URLRequest) -> AnyPublisherType {
        return dataTaskPublisher(for: request)
            .eraseToAnyPublisher()
    }
}
