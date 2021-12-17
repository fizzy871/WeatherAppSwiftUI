//
//  DispatchQueue+.swift
//  WeatherAppSwiftUI
//
//  Created by Alexey on 12/17/21.
//

import Foundation

extension DispatchQueue {
    static func onMain(_ closure: @escaping () -> ()) {
        if Thread.current.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    static func onMainSync(_ closure: @escaping () -> ()) {
        if Thread.current.isMainThread {
            closure()
        } else {
            DispatchQueue.main.sync {
                closure()
            }
        }
    }
}
