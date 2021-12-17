//
//  ContentView.swift
//  WeatherAppSwiftUI
//
//  Created by Alexey on 12/16/21.
//

import SwiftUI
import CoreLocation
import Combine

struct ContentView: View {
//    @State var weather: API.CurrentWeather.Response?
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .welcome:
                WelcomeView(requestLocation: { viewModel.requestLocation() })
            case .coordinatesFetched(let coordinates):
                VStack {
                    Text("Your coordinates are: \(coordinates.longitude), \(coordinates.latitude)")
                    ProgressView()
                }
                .task {
                    await viewModel.fetchWeather(from: coordinates)
                }
            case .weatherFetched(let weather):
                WeatherView(weather: weather)
            case .failed(let error):
                Text("Error: \(error.localizedDescription)")
            case .loading:
                LoadingView()
            }
        }
        .background(Color.background)
        .preferredColorScheme(.dark)
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        // MARK: Private variables
        private let apiManager: WeatherManager
        // MARK: Public variables
        @Published public var viewState: ViewState = .welcome
        // MARK: Nested objects
        enum ViewState {
            case welcome
            case loading
            case coordinatesFetched(CLLocationCoordinate2D)
            case weatherFetched(API.CurrentWeather.Response)
            case failed(Swift.Error)
        }
        
        // MARK: Lifecycle
        init(apiManager: WeatherManager = WeatherManager()) {
            self.apiManager = apiManager
        }
        
        // MARK: Public interface
        public func requestLocation() {
            viewState = .loading
            LocationManager().requestLocation { result in
                switch result {
                case .success(let coordinates):
                    self.viewState = .coordinatesFetched(coordinates)
                case .failure(let error):
                    self.viewState = .failed(error)
                }
            }
        }
        public func fetchWeather(from coordinates: CLLocationCoordinate2D) async {
            do {
                let weather = try await apiManager.getCurrentWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                DispatchQueue.onMain {
                    self.viewState = .weatherFetched(weather)
                }
            } catch {
                DispatchQueue.onMain {
                    self.viewState = .failed(error)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
