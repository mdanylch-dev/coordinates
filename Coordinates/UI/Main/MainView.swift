//
//  MainView.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 14.02.2025.
//

import SwiftUI

struct MainView<VM>: View where VM: MainViewModelType {
    @ObservedObject var viewModel: VM
    private enum Field {
            case long, lat
    }
    @FocusState private var focusedField: Field?
    @State private var latestValidation: Validation = .failure(message: "")

    var body: some View {
        content
    }

    var content: some View {
        VStack(spacing: 0) {
            inputCard

            if viewModel.temperature != nil {
                updateInfo
                    .padding(.vertical, 8)

                infoCard
            } else if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding(.top, 32)
            } else {
                Text("Оберіть координати")
                    .fontKit(style: .h2)
                    .padding(.top, 32)
            }
            Spacer()
        }
        .background(ColorsKit.Bg.color)
        .onTapGesture { focusedField = nil }
        .ignoresSafeArea(.keyboard)
    }

    var inputCard: some View {
        VStack {
            Text("Координати для прогнозу погоди")
                .fontKit(style: .h1)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16)

            TextFieldKit(
                "Введіть координати",
                height: 48,
                text: $viewModel.longitudeText,
                label: "Довгота",
                validationPublisher: viewModel.longitudeValidation
            )
            .keyboardType(.decimalPad)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .textContentType(.oneTimeCode)
            .focused($focusedField, equals: .long)
            .highPriorityGesture(TapGesture().onEnded{
                focusedField = .long
            })

            TextFieldKit(
                "Введіть координати",
                height: 48,
                text: $viewModel.latitudeText,
                label: "Широта",
                validationPublisher: viewModel.latitudeValidation
            )
            .keyboardType(.decimalPad)
            .padding(.top, 16)
            .focused($focusedField, equals: .lat)
            .highPriorityGesture(TapGesture().onEnded{
                focusedField = .lat
            })

            HStack(spacing: 0) {
                ButtonBuilder(isActive: viewModel.isClearEnabled)
                    .title("Скинути")
                    .style(style: .secondaryStyle)
                    .action {
                        viewModel.clearFields()
                    }
                    .build()
                Spacer(minLength: 16)
                ButtonBuilder(isActive: viewModel.isFetchEnabled)
                    .title("Застосувати")
                    .action {
                        focusedField = nil
                        viewModel.fetchWeather()
                    }
                    .build()
                    .onReceive(viewModel.isAllValid, perform: {
                        latestValidation = $0
                    })
            }
            .padding(.vertical, 16)
        }
        .padding()
        .background(ColorsKit.Surface.color)
        .cornerRadius(16)
        .padding()
    }

    var updateInfo: some View {
        HStack() {
            Text("Останнє оновлення даних")
                .fontKit(style: .body2, color: .Secondary)
            Spacer()
            Text(Date().formattedDate())
                .fontKit(style: .h3)
        }
        .padding(.horizontal, 16)
    }

    var infoCard: some View {
        VStack(spacing: 32) {
            Text("Прогноз")
                .fontKit(style: .h1)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    if let weather = viewModel.temperature {
                        weatherCell(weather)
                    }
                    if let weather = viewModel.dewPoint {
                        weatherCell(weather)
                    }
                }
                HStack(spacing: 20) {
                    if let weather = viewModel.pressure {
                        weatherCell(weather)
                    }
                    if let weather = viewModel.humidity {
                        weatherCell(weather)
                    }
                }
            }
        }
        .padding()
        .background(ColorsKit.Surface.color)
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }

    private func weatherCell(_ weather: WeatherDetails) -> some View {
        VStack(alignment: .leading) {
            Text(weather.title)
                .fontKit(style: .h3, color: .Secondary)
            HStack {
                weather.image
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(weather.indicator)
                    .fontKit(style: .h2, color: .Main)
                Spacer(minLength: 0)
            }
        }
    }
}
