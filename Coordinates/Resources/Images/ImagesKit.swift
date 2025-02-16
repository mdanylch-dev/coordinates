//
//  Images.swift
//  Coordinates
//
//  Created by Mykyta Danylchenko on 16.02.2025.
//

import SwiftUI

struct ImagesKit: Equatable {
    var uiImage: UIImage

    var image: Image {
        Image(uiImage: uiImage)
    }

    private init(name: String) {
        self.uiImage = UIImage(named: name)!
    }
    static let DewPoint: ImagesKit = .init(name: "dew point")
    static let Humidity: ImagesKit = .init(name: "humidity")
    static let Pressure: ImagesKit = .init(name: "pressure")
    static let Temperature: ImagesKit = .init(name: "temperature")
}
