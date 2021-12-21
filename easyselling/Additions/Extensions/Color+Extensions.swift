//
//  Color+Extensions.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 03/11/2021.
//

import SwiftUI

extension ColorAsset {
    var swiftUIColor: SwiftUI.Color {
        return SwiftUI.Color(cgColor: color.cgColor)
    }
}
