//
//  LocationManager.swift
//  WeatherAppSwiftUI
//
//  Created by Alexey on 12/16/21.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    typealias Completion = (Result<CLLocationCoordinate2D, Swift.Error>) -> Void
    // MARK: Private variables
    private static var instances = [LocationManager]()
    private let manager = CLLocationManager()
    private var completion: Completion?
    
    // MARK: Lifecycle
    override init() {
        super.init()
        manager.delegate = self
    }
}

extension LocationManager {
    // MARK: Public interface
    public func requestLocation(completion: @escaping Completion) {
        self.completion = completion
        Self.instances.append(self)
        manager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            self.completion?(.success(location))
        } else {
            self.completion?(.failure(Error.failedToGetCoordinates))
        }
        Self.instances.removeAll(where: {$0 === self})
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        self.completion?(.failure(Error.coreLocationError(error)))
        Self.instances.removeAll(where: {$0 === self})
    }
}

extension LocationManager {
    // MARK: Nested objects
    enum Error: Swift.Error {
        case failedToGetCoordinates
        case coreLocationError(Swift.Error)
    }
}
