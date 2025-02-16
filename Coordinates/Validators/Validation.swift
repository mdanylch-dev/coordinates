//
//  Validation.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 15.02.2025.
//

import Foundation
import Combine

typealias ValidationErrorClosure = () -> String
typealias ValidationPublisher = AnyPublisher<Validation, Never>

enum Validation {
    case success
    case failure(message: String)

    var isSuccess: Bool {
        if case .success = self {
            return true
        }

        return false
    }
}

final class ValidationPublishers {
    static func nonEmptyValidation(
        for publisher: Published<String>.Publisher,
        errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> ValidationPublisher {
        return publisher.map { value in
            guard !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return .failure(message: errorMessage())
            }

            return .success
        }
        .eraseToAnyPublisher()
    }

    static func validSymbolsValidation(
        symbols: String,
        for publisher: Published<String>.Publisher,
        errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> ValidationPublisher {
        return publisher.map { value in
            return NSPredicate(format: "SELF MATCHES %@", symbols).evaluate(with: value) ?  .success : .failure(message: errorMessage())
        }
        .eraseToAnyPublisher()
    }

    static func doubleRangeValidation(
        range: ClosedRange<Double>,
        for publisher: Published<String>.Publisher,
        errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> ValidationPublisher {
        return publisher.map { value in
            guard let value = value.toDouble() else { return .failure(message: errorMessage())}
            return (range).contains(value) ? .success : .failure(message: errorMessage())
        }
        .eraseToAnyPublisher()
    }
}

extension String {
    func toDouble() -> Double? {
        let value = self.replacingOccurrences(of: ",", with: ".")
        return Double(value)
    }
}
