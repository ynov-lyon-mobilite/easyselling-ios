//
//  FakeURLSession.swift
//  easysellingTests
//
//  Created by Maxence on 10/11/2021.
//

import Foundation
@testable import easyselling

class FakeUrlSession: URLSessionProtocol {
    
    private var data: Data = Data()
    private var response: URLResponse = URLResponse()

    init() {}
    
    init(expected response: URLResponse, with data: Data = Data()) {
        self.data = data
        self.response = response
    }
    
    init(localFile: LocalFile) {
        self.data = localFile.data
        self.response = HTTPURLResponse(url: URL(string: "https://google.com/osef")!, statusCode: 200,
                                        httpVersion: nil, headerFields: nil)!
    }

    init(localImage: LocalFile) {
        self.data = localImage.image
        self.response = HTTPURLResponse(url: URL(string: "https://google.com/osef")!, statusCode: 200,
                                        httpVersion: nil, headerFields: nil)!
    }

    func data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        return (data, response)
    }
}
