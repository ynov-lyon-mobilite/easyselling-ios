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
    
    func call<T: Decodable>(_ urlRequest: URLRequest, decodeType: T.Type) -> T {
        return "" as! T
    }
    
    func call(_ urlRequest: URLRequest) {
        return
    }
}
