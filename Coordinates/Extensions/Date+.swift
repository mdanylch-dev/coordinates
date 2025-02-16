//
//  Date+.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 16.02.2025.
//

import Foundation

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        formatter.locale = Locale(identifier: "uk_UA")
        return formatter.string(from: self)
    }
}
