//
//  APIResponse.swift
//  easyselling
//
//  Created by Maxence on 20/10/2021.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let data: T
}
