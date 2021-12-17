//
//  URL+.swift
//  WeatherAppSwiftUI
//
//  Created by Alexey on 12/17/21.
//

import Foundation

extension URL {
    func load<T: Decodable>() throws -> T {
        let data = try Data(contentsOf: self)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

