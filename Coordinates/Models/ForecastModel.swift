//
//  ForecastModel.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 14.02.2025.
//

import SwiftUI

struct ForecastModel: Decodable {
    let pressureRaw: Int
    let temperatureRaw: Double
    let humidityRaw: Int
    let dewPointRaw: String

    enum CodingKeys: String, CodingKey {
        case main
    }

    enum MainKeys: String, CodingKey {
        case pressure, temp, humidity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mainContainer = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)

        pressureRaw = try mainContainer.decode(Int.self, forKey: .pressure)
        temperatureRaw = try mainContainer.decode(Double.self, forKey: .temp)
        humidityRaw = try mainContainer.decode(Int.self, forKey: .humidity)
        dewPointRaw = temperatureRaw.toDewPoint(with: humidityRaw)
    }
}

extension Double {
    // Calculate dew point
    func toDewPoint(with humidity: Int) -> String {
        let a = 17.27
        let b = 237.7
        let tempCelsius = self
        let humidityFraction = Double(humidity) / 100.0

        let alpha = ((a * tempCelsius) / (b + tempCelsius)) + log(humidityFraction)
        let result = (b * alpha) / (a - alpha)
        return String(format: "%.0f", result)
    }
}

struct WeatherDetails {
    let id: UUID
    let image: Image
    let title: String
    let indicator: String
}

extension ForecastModel {
    var temperature: WeatherDetails {
        let weather = WeatherDetails(
            id: UUID(),
            image: ImagesKit.Temperature.image,
            title: "t° повітря",
            indicator: String(format: "%.0f", self.temperatureRaw) + " °С"
        )
        return weather
    }


    var pressure: WeatherDetails {
        let weather = WeatherDetails(
            id: UUID(),
            image: ImagesKit.Pressure.image,
            title: "Атмосферний тиск",
            indicator:  "\(self.pressureRaw) мм рт. ст."
        )
        return weather
    }

    var dewPoint: WeatherDetails {
        let weather = WeatherDetails(
            id: UUID(),
            image: ImagesKit.DewPoint.image,
            title: "Точка роси",
            indicator: "\(self.dewPointRaw) °С"
        )
        return weather
    }

    var humidity: WeatherDetails {
        let weather = WeatherDetails(
            id: UUID(),
            image: ImagesKit.Humidity.image,
            title: "",
            indicator: "\(self.humidityRaw) %"
        )
        return weather
    }
}
