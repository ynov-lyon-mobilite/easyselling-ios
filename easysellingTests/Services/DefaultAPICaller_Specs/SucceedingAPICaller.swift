//
//  SucceedingAPICaller.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 16/10/2021.
//

import Foundation
import Combine
@testable import easyselling
import UIKit

class SucceedingAPICaller: APICaller {
    
    private(set) var isCallSucceed: Bool = false
    typealias type<T: Any> = () -> T
    let callback: type<Any>

    init(callback: @escaping type<Any>) {
        self.callback = callback
    }

    func call<T: Decodable>(_ urlRequest: URLRequest, decodeType: T.Type) -> T {
        return callback() as! T
    }
    
    func call(_ urlRequest: URLRequest) {
        isCallSucceed = true
        return
    }

    func callImage(_ urlRequest: URLRequest) async throws -> UIImage {
        UIImage()
    }
}
