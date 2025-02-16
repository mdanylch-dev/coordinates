////
////  ButtonStyle.swift
////  Coordinates
////
////  Created by Mykyta Danylchenko on 14.02.2025.
////
//
//import SwiftUI
//
//enum ButtonStyles {
//    case defaultStyle
//    case disabledStyle
//}
//
//struct ButtonKit: View {
//    let id: UUID = UUID()
//    let type: ButtonStyles
//    let action: () -> Void
//    let title: String
//    private var width: CGFloat
//    private var height: CGFloat
//
//    @State private var isButtonPressed = false
//
//    init(type: ButtonStyles, width: CGFloat = 160, height: CGFloat = 44, title: String, action: @escaping () -> Void) {
//        self.type = type
//        self.action = action
//        self.title = title
//        self.width = width
//        self.height = height
//    }
//    var body: some View {
//        var backgroundColor = PXDColor.Clear
//        var textColor = PXDColor.Clear
//        var buttonOpacity: Double = 1
//        switch type {
//        case .:
//            textColor = PXDColor.White
//            backgroundColor = PXDColor.Primary.Light
//        case .hoverStyle:
//            textColor = PXDColor.White
//            backgroundColor = PXDColor.Primary.Dark
//        case .activeStyle:
//            textColor = PXDColor.Black
//            backgroundColor = PXDColor.White
//        case .disabledStyle:
//            textColor = PXDColor.Black
//            backgroundColor = PXDColor.BGGray
//            buttonOpacity = 0.4
//        }
//        return Button(
//            action: {
//                guard !isButtonPressed else {
//                    return
//                }
//                isButtonPressed = true
//                action()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    isButtonPressed = false
//                }
//            },
//            label: {
//                Text(title)
//                    .frame(maxWidth: width, minHeight: height, maxHeight: height)
//                    .pixioFont(style: .bodyHead, color: textColor)
//                    .border(PXDColor.Border.color, width: 0.75)
//            }
//        )
//        .background(backgroundColor.color)
//        .opacity(buttonOpacity)
//        .allowsHitTesting(!isButtonPressed)
//    }
//}
//
