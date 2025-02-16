//
//  View+.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 15.02.2025.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View {
    var asAnyView: AnyView { AnyView(self) }

    func fontKit(
        style: FontKitStyle,
        color: ColorsKit = .Main
    ) -> some View {
        self.modifier(FontKitModifier(fontStyle: style, textColor: color))
    }
}

private struct FontKitModifier: ViewModifier {
    var fontStyle: FontKitStyle
    var textColor: ColorsKit

    func body(content: Content) -> some View {
        content
            .font(self.fontStyle.font)
            .foregroundColor(self.textColor.color)
    }
}
