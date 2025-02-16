//
//  ValidatorString.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 15.02.2025.
//

import Foundation

extension Published.Publisher where Value == String {
    func nonEmptyValidator(_ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.nonEmptyValidation(for: self, errorMessage: errorMessage())
    }

    func validSymbolsValidator(_ symbols: String, _ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.validSymbolsValidation(symbols: symbols, for: self, errorMessage: errorMessage())
    }

    func doubleRangeValidator(_ value: ClosedRange<Double>, _ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.doubleRangeValidation(range: value, for: self, errorMessage: errorMessage())
    }
}

