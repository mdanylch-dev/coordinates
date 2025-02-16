//
//  ButtonKitBuilder.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 14.02.2025.
//

import SwiftUI

class ButtonBuilder {
    private var view: KitButton

    public init(isActive: Bool, width: CGFloat = 160, height: CGFloat = 44) {
        self.view = KitButton(isActive: isActive, width: width, height: height)
    }

    public func style(style: ButtonKitStyle = .primaryStyle) -> ButtonBuilder {
        self.view.type = style
        self.view.isBorderNeeded = style == .secondaryStyle
        return self
    }

    public func title(_ text: String, with font: FontKitStyle = .h2) -> ButtonBuilder {
        self.view.title = text
        self.view.titleFont = font
        return self
    }

    public func action(_ action: @escaping () -> Void) -> ButtonBuilder {
        self.view.action = action
        return self
    }

    public func build() -> KitButton {
        view
    }
}

