//
//  MainViewModel.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 14.02.2025.
//

import Foundation
import Combine

class MainViewModel: MainViewModelType {

    let COORDINATE_SYMBOLS: String = #"^-?[0-9]*[.,]?[0-9]*$"#

    private let cancelBag = CancelBag()
    private let weatherService = NetworkService()

    // Bindings
    @Published var longitudeText = "" {
        didSet {
            let value = !longitudeText.isEmpty
            isLongitudeValidationActive = value
            isClearEnabled = value
        }
    }
    @Published var latitudeText = "" {
        didSet {
            let value = !latitudeText.isEmpty
            isLatitudeValidationActive = value
            isClearEnabled = value
        }
    }

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
    @Published var latestValidation: Validation = .failure(message: "")

    lazy var latitudeLimitValidation: ValidationPublisher = {
        return $latitudeText.doubleRangeValidator(-90.0...90.0, "Неправильно введені координати")
    }()

    lazy var longitudeLimitValidation: ValidationPublisher = {
        return $longitudeText.doubleRangeValidator(-180.0...180.0, "Неправильно введені координати")
    }()

    lazy var latitudeSymbolsValidation: ValidationPublisher = {
        return $longitudeText.validSymbolsValidator(COORDINATE_SYMBOLS, "Неправильно введені координати")
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
        Publishers.CombineLatest(longitudeValidation, latitudeValidation)
            .map({ [weak self] long, lat in
                let isAllValid = [long, lat].allSatisfy { $0.isSuccess }

                self?.isFetchEnabled = isAllValid
                if isAllValid {
                    return .success
                } else {
                    return [long, lat].first(where: { !$0.isSuccess }) ?? .success
                }
            })
            .eraseToAnyPublisher()
    }()

    // MARK: - Intialization
    init() { }

    func fetchWeather() {
        isLoading = true
        let coordinates = "&lon=\(longitudeText)&lat=\(latitudeText)"
        weatherService.fetchWeather(for: coordinates)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                default:
                    break
                }
            }, receiveValue: { [weak self] forecast in
                guard let self = self else { return }
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
        temperature = nil
        pressure = nil
        dewPoint = nil
        humidity = nil
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
}
