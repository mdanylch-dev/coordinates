//
//  TextFieldKit.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 15.02.2025.
//

import SwiftUI
import Combine

struct TextFieldKit: View {
    let placeholder: String
    let label: String
    @Binding var text: String

    @State private var isActive: Bool = false

    @State private var latestValidation: Validation = .success

    private let validationPublisher: ValidationPublisher

    private let height: CGFloat
    private let isDisabled: Bool = false

    private let onCommit: () -> Void

    private let cancelBag = CancelBag()

    private var borderColor: Color {
        switch latestValidation {
        case .failure :
            guard text.isEmpty else { fallthrough }
            return ColorsKit.Error.color
        case .success:
            guard !isActive else { return ColorsKit.Accent.color }
            return isDisabled ? ColorsKit.Disabled.color : ColorsKit.Secondary.color

        }
    }

    private var labelColor: ColorsKit {
        return latestValidation.isSuccess ? .Accent : .Error
    }

    init(
        _ placeholder: String,
        height: CGFloat = 48,
        text: Binding<String>,
        label: String,
        validationPublisher: ValidationPublisher? = nil,
        onCommit: @escaping (() -> Void) = {}
    ) {
        self.placeholder = placeholder
        self._text = text
        self.validationPublisher = validationPublisher ?? Just<Validation>(.success).eraseToAnyPublisher()
        self.height = height
        self.onCommit = onCommit
        self.label = label
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .fontKit(style: .body3, color: labelColor)
                .padding(.bottom, 4)
            TextField("", text: $text, onEditingChanged: {
                isActive = $0
            }, onCommit: onCommit)
            .placeholder(when: text.isEmpty, placeholder: {
                Text(placeholder)
                    .foregroundColor(ColorsKit.Secondary.color)
            })
            .fontKit(style: .body1, color: .Main)
            .frame(height: height, alignment: .center)
            .padding(.horizontal, 16)
            .background(ColorsKit.Surface.color)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            )
            .lineLimit(1)
            .disableAutocorrection(true)

            validationMessage
                .transition(.move(edge: .top))
                .padding(.top, 4)
        }
        .onReceive(validationPublisher, perform: {
            latestValidation = $0
        })
    }

    var validationMessage: some View {
        switch latestValidation {
        case .success:
            return AnyView(EmptyView())
        case .failure(let message):
            let text = Text(message)
                .fontKit(style: .body3, color: .Error)
            return AnyView(text)
        }
    }
}
