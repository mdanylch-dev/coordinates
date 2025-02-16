//
//  NetworkService.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 14.02.2025.
//

import Foundation
import Combine

struct NetworkService {
    private let cancelBag = CancelBag()

    private let urlStringWeather = "https://api.openweathermap.org/data/2.5/weather/?"
    private let units = "&units=metric"
    private let apiKey = "&appid=9187423fa8d4ffc730a26f03aea4d70c"

    func fetchWeather(for coordinates: String) -> AnyPublisher<ForecastModel, Error> {

        let urlEndpoint = urlStringWeather + coordinates + units + apiKey
        let url = URL(string: urlEndpoint)!

        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: ForecastModel.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
