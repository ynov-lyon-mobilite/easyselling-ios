//
//  Notification+Extensions.swift
//  easyselling
//
//  Created by Nicolas Barbosa on 01/04/2022.
//

import Foundation
import SwiftUI

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}
