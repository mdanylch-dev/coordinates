//
//  MainViewModel.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 14.02.2025.
//

import Foundation
import Combine

class MainViewModel: MainViewModelType {

    let COORDINATE_SYMBOLS: String = #"^-?[0-9]{1,4}([.,][0-9]{0,30})?$"#

    private let cancelBag = CancelBag()
    private let weatherService = NetworkService()

    // Bindings
    @Published var longitudeText = ""
    @Published var latitudeText = ""
    @Published var isError: Bool = false

    // Outputs
    @Published private(set) var temperature: WeatherDetails?
    @Published private(set) var dewPoint: WeatherDetails?
    @Published private(set) var pressure: WeatherDetails?
    @Published private(set) var humidity: WeatherDetails?
    @Published private(set) var isFetchEnabled: Bool = false
    @Published private(set) var isClearEnabled: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private var isLatitudeValidationActive: Bool = false
    @Published private var isLongitudeValidationActive: Bool = false
    @Published private var isValidationActive: Bool = false
    @Published var latestValidation: Validation = .failure(message: "")

    lazy var latitudeLimitValidation: ValidationPublisher = {
        return $latitudeText.doubleRangeValidator(-90.0...90.0, "Неправильно введені координати")
    }()

    lazy var longitudeLimitValidation: ValidationPublisher = {
        return $longitudeText.doubleRangeValidator(-180.0...180.0, "Неправильно введені координати")
    }()

    lazy var latitudeSymbolsValidation: ValidationPublisher = {
        return $latitudeText.validSymbolsValidator(COORDINATE_SYMBOLS, "Неправильно введені координати")
    }()

    lazy var longitudeSymbolsValidation: ValidationPublisher = {
        return $longitudeText.validSymbolsValidator(COORDINATE_SYMBOLS, "Неправильно введені координати")
    }()


    lazy var latitudeValidation: ValidationPublisher = {
        Publishers.CombineLatest3(latitudeLimitValidation, latitudeSymbolsValidation, $isLatitudeValidationActive)
            .map({ latitudeLimitValidation, latitudeSymbolsValidation, isValidationActive in
                let isAllValid = [latitudeLimitValidation, latitudeSymbolsValidation].allSatisfy { $0.isSuccess }

                if isAllValid || !isValidationActive {
                    return .success
                } else {
                    return [latitudeLimitValidation, latitudeSymbolsValidation].first(where: { !$0.isSuccess }) ?? .success
                }
            })
            .eraseToAnyPublisher()
    }()

    lazy var longitudeValidation: ValidationPublisher = {
        Publishers.CombineLatest3(longitudeLimitValidation, longitudeSymbolsValidation, $isLongitudeValidationActive)
            .map({ longitudeLimitValidation, longitudeSymbolsValidation, isValidationActive in
                let isAllValid = [longitudeLimitValidation, longitudeSymbolsValidation].allSatisfy { $0.isSuccess }

                if isAllValid || !isValidationActive {
                    return .success
                } else {
                    return [longitudeLimitValidation, longitudeSymbolsValidation].first(where: { !$0.isSuccess }) ?? .success
                }
            })
            .eraseToAnyPublisher()
    }()

    lazy var isAllValid: ValidationPublisher = {
        Publishers.CombineLatest3(longitudeValidation, latitudeValidation, $isValidationActive)
            .map({ [weak self] long, lat, isActive in
                let isAllValid = [long, lat].allSatisfy { $0.isSuccess }

                DispatchQueue.main.async {
                    self?.isFetchEnabled = isAllValid && isActive
                }
                if isAllValid && isActive {
                    return .success
                } else {
                    return [long, lat].first(where: { !$0.isSuccess }) ?? .success
                }
            })
            .eraseToAnyPublisher()
    }()

    // MARK: - Intialization
    init() {

        $longitudeText
            .throttle(for: .seconds(0.3), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] text in
                guard let self else { return }
                self.isLongitudeValidationActive = !text.isEmpty
            }
            .store(in: cancelBag)

        $latitudeText
            .throttle(for: .seconds(0.3), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] text in
                guard let self else { return }
                self.isLatitudeValidationActive = !text.isEmpty
            }
            .store(in: cancelBag)

        Publishers.Merge($longitudeText, $latitudeText)
            .sink { [weak self] _ in
                guard let self else { return }
                isClearEnabled = !self.latitudeText.isEmpty || !self.longitudeText.isEmpty
            }
            .store(in: cancelBag)

        Publishers.CombineLatest($longitudeText, $latitudeText)
            .sink { [weak self] longField, latField in
                guard let self else { return }
                isValidationActive = !longField.isEmpty && !latField.isEmpty
            }
            .store(in: cancelBag)
    }

    func fetchWeather() {
        isLoading = true
        let coordinates = "&lon=\(longitudeText)&lat=\(latitudeText)"
        weatherService.fetchWeather(for: coordinates)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.clearPrevious()
                    self?.isError = true
                    print(error)
                default:
                    break
                }
            }, receiveValue: { [weak self] forecast in
                guard let self, isLoading else { return }
                self.temperature = forecast.temperature
                self.pressure = forecast.pressure
                self.dewPoint = forecast.dewPoint
                self.humidity = forecast.humidity
                isLoading = false
            })
            .store(in: self.cancelBag)
    }

    func clearFields() {
        longitudeText = ""
        latitudeText = ""
        isClearEnabled = false
        clearPrevious()
    }

    private func clearPrevious() {
        temperature = nil
        pressure = nil
        dewPoint = nil
        humidity = nil
        isLoading = false
    }
}

// MARK: - View model protocol
protocol MainViewModelType: ObservableObject {
    // Inputs
    func fetchWeather()
    func clearFields()

    // Outputs
    var temperature: WeatherDetails? { get }
    var dewPoint: WeatherDetails? { get }
    var pressure: WeatherDetails? { get }
    var humidity: WeatherDetails? { get }
    var isFetchEnabled: Bool { get }
    var isClearEnabled: Bool { get }
    var isLoading: Bool { get }
    var longitudeValidation: ValidationPublisher { get }
    var latitudeValidation: ValidationPublisher { get }
    var isAllValid: ValidationPublisher { get }

    // Bindings
    var longitudeText: String { get set }
    var latitudeText: String { get set }
    var isError: Bool { get  set }
}
