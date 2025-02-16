//
//  Colors.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 14.02.2025.
//

import SwiftUI

struct ColorsKit {
    static let Accent: ColorsKit = .init(name: "accent")
    static let AccentDisabled: ColorsKit = .init(name: "accent_disabled")
    static let AccentFocused: ColorsKit = .init(name: "accent_focused")
    static let Bg: ColorsKit = .init(name: "bg")
    static let Disabled: ColorsKit = .init(name: "disabled")
    static let Error: ColorsKit = .init(name: "error")
    static let Main: ColorsKit = .init(name: "main")
    static let Secondary: ColorsKit = .init(name: "secondary")
    static let Surface: ColorsKit = .init(name: "surface")
    static let Clear: ColorsKit = .init(uiColor: .clear)

    public var uiColor: UIColor

    public var color: Color {
        Color(uiColor)
    }

    public var cgColor: CGColor {
        uiColor.cgColor
    }

    private init(name: String) {
        self.uiColor = UIColor(named: name)!
    }

    private init(uiColor: UIColor) {
        self.uiColor = uiColor
    }
}

