//
//  View+Extensions.swift
//  easyselling
//
//  Created by Maxence on 07/12/2021.
//

import Foundation
import SwiftUI

extension View {
    func fillMaxWidth(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }

    func fillMaxHeight(alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }

    func fillMaxSize(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }

    func ableToShowError(_ error: String, when isShowingError: Bool) -> some View {
        modifier(ErrorShower(error: error, isShowingError: isShowingError))
    }
}
