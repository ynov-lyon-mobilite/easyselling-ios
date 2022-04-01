//
//  Publishers+Extensions.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 01/04/2022.
//

import Foundation
import Combine
import SwiftUI

extension Publishers {

    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }

        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(20) }

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
