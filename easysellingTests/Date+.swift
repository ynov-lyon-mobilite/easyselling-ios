//
//  Date+.swift
//  easysellingTests
//
//  Created by Nicolas Barbosa on 10/05/2022.
//

import Foundation

extension Date {

    var zeroSeconds: Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        guard let date = calendar.date(from: dateComponents) else { return Date() }
        return date
    }

}
