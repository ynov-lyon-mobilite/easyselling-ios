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

    func ableToShowError(_ error: LocalizedError?) -> some View {
        modifier(ErrorShower(error: error))
    }

    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    func modal<Content: View>(isModalized: Binding<Bool>, @ViewBuilder modalContent: @escaping () -> Content) -> some View {
        return ModalizedView(modalizedContent: self, modalContent: modalContent, isModalized: isModalized)
    }

    @ViewBuilder func redacted(when condition: Bool) -> some View {
        if condition {
            redacted(reason: .placeholder)
        } else {
            unredacted()
        }
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
