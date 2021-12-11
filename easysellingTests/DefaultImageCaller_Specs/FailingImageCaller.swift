//
//  FailingImageCaller.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 11/12/2021.
//

@testable import easyselling
import UIKit

class FailingImageCaller: ImageCaller {

    init(withError error: Int) {
        self.error = error
    }

    private let error: Int

    func callImage(_ urlRequest: URLRequest) async throws -> UIImage {
        throw APICallerError.from(statusCode: error)
    }
}
