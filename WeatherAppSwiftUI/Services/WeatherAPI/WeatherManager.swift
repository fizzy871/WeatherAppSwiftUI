//
//  WeatherManager.swift
//  WeatherAppSwiftUI
//
//  Created by Alexey on 12/16/21.
//

import Foundation
import CoreLocation

class WeatherManager {
    
}

extension WeatherManager {
    // MARK: Public interface
    public func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> API.CurrentWeather.Response {
        let url = API.CurrentWeather(latitude: latitude, longitude: longitude).url()
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw Error.statusCode200 }
        let decodedResponse = try JSONDecoder().decode(API.CurrentWeather.Response.self, from: data)
        return decodedResponse
    }
}

extension WeatherManager {
    // MARK: Nested objects
    enum Error: Swift.Error {
        case statusCode200
    }
}
