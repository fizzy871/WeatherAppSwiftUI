//
//  String+.swift
//  WeatherAppSwiftUI
//
//  Created by Alexey on 12/17/21.
//

import Foundation

extension Double {
    func string(decimals: Int = 0) -> String {
        return String(format: "%.\(decimals)f", self)
    }
}
