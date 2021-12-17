//
//  APITests.swift
//  WeatherAppSwiftUI
//
//  Created by Alexey on 12/17/21.
//

import Foundation
@testable import WeatherAppSwiftUI
import XCTest

class APITests: XCTestCase {
    func testCurrentWeather() async throws {
        do {
            let _ = try await WeatherManager().getCurrentWeather(latitude: 0, longitude: 0)
        } catch {
            XCTFail("\(error)")
        }
    }
}
