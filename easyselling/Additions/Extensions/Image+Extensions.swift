//
//  Image+Extensions.swift
//  easyselling
//
//  Created by Maxence on 07/12/2021.
//

import SwiftUI

extension Image {
    init(_ image: ImageAsset) {
        self.init(uiImage: image.image)
    }
}
