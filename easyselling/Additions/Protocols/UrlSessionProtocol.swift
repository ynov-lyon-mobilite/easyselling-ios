//
//  URLSessionProtocol.swift
//  easyselling
//
//  Created by Maxence on 13/10/2021.
//

import Foundation
import Combine

protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
