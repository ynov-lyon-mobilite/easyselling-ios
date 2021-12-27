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
    
    func call<T: Decodable>(_ urlRequest: URLRequest, decodeType: T.Type) -> T {
        return "" as! T
    }
    
    func call(_ urlRequest: URLRequest) {
        isCallSucceed = true
        return
    }

    func callImage(_ urlRequest: URLRequest) async throws -> UIImage {
        UIImage()
    }
}
