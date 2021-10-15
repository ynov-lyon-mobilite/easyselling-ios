//
//  APIResponse.swift
//  easyselling
//
//  Created by Maxence on 15/10/2021.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let data: T
}
