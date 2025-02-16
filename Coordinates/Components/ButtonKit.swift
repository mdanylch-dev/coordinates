//
//  ButtonKit.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 14.02.2025.
//

import SwiftUI

enum ButtonKitStyle {
    case primaryStyle
    case secondaryStyle

    var isBorderNeeded: Bool {
        switch self {
        case .secondaryStyle:
            return true
        default:
            return false
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .primaryStyle, .secondaryStyle:
            24
        }
    }

    func bgColor(_ isActive: Bool) -> ColorsKit {
        switch self {
        case .primaryStyle:
            return isActive ? .Accent : .AccentDisabled
        case .secondaryStyle: return .Surface
        }
    }

    func borderColor(_ isActive: Bool) -> ColorsKit {
        switch self {
        case .secondaryStyle:
            return isActive ? .Accent : .AccentDisabled
        default:
            return .Clear
        }
    }

    func textColor(_ isActive: Bool) -> ColorsKit {
        switch self {
        case .primaryStyle:
            return .Surface
        case .secondaryStyle:
            return isActive ? .Accent : .AccentDisabled
        }
    }

    var textColorDisabled: ColorsKit {
        switch self {
        case .primaryStyle:
                .Surface
        case .secondaryStyle:
                .Accent
        }
    }

}

public struct KitButton: View {

    var isActive: Bool
    var width: CGFloat
    var height: CGFloat
    var type: ButtonKitStyle = .primaryStyle
    var title: String?
    var isBorderNeeded: Bool = true
    var borderColor: ColorsKit = .Accent
    var titleFont: FontKitStyle = .h2
    var titleColor: ColorsKit = .Surface

    var action: (() -> Void)?

    public var body: some View {
        Button(action: { action?() }, label: {
            buttonLabel
        })
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .background(type.bgColor(isActive).color)
        .foregroundColor(titleColor.color)
        .cornerRadius(type.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: type.cornerRadius)
                .stroke(type.borderColor(isActive).color, lineWidth: 1)
        )
        .disabled(!isActive)
    }

    public var buttonLabel: some View {
        Text(title ?? "")
            .fontKit(style: titleFont, color: type.textColor(isActive))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

