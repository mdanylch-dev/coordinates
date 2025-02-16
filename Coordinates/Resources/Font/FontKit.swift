//
//  FontKit.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 14.02.2025.
//

import SwiftUI

enum FontKitStyle {
    case h1, h2, h3
    case body1, body2, body3

    var fontName: String {
        switch self {
        case .h1, .h2:
            return "Roboto-SemiBold"
        case .h3:
            return "Roboto-Bold"
        case .body1, .body2, .body3:
            return "Roboto-Regular"
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .h1: return 20
        case .h2, .body1: return 16
        case .h3, .body2: return 14
        case .body3: return 12
        }
    }

    var lineHeight: CGFloat {
        switch self {
        case .h1: return 1.1
        case .body1, .body3, .h2, .h3: return 1.2
        case .body2: return 1.15
        }
    }

    var font: Font {
        Font.custom(fontName, size: fontSize)
    }

    var lineSpacing: CGFloat {
        (lineHeight - 1) * fontSize
    }
}

//extension Text {
//    func fontKit(_ style: FontKitStyle, color: ColorsKit = .Main) -> some View {
//        self.font(style.font).lineSpacing(style.lineSpacing)
//    }
//}
//
