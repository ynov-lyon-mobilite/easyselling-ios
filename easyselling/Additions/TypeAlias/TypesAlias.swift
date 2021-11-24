//
//  TypesAlias.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 13/10/2021.
//

import Foundation
import Combine

typealias Action = () -> Void
typealias AsyncableAction = () async -> Void
typealias OnUpdatingVehicle = (Vehicle, @escaping AsyncableAction) -> Void
