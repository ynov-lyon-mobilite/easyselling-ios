//
//  UrlSessionProtocol.swift
//  easyselling
//
//  Created by Maxence on 13/10/2021.
//

import Foundation
import Combine

protocol UrlSessionProtocol {
    typealias AnyPublisherType = AnyPublisher<(data: Data, response: URLResponse), URLError>

    func dataTaskAnyPublisher(for request: URLRequest) -> AnyPublisherType
}
