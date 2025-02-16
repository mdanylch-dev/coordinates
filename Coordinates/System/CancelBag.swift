//
//  CancelBag.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 14.02.2025.
//

import Combine

final class CancelBag {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()

    func cancel() {
        subscriptions.removeAll()
    }

    func cancel(subscription: AnyCancellable) {
        subscriptions.remove(subscription)
    }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}

