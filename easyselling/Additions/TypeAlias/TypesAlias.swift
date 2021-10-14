//
//  TypesAlias.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import Combine

typealias Action = () -> Void
typealias VoidResult = AnyPublisher<Void, HTTPError>
typealias DecodedResult<T: Decodable> = AnyPublisher<T, HTTPError>
