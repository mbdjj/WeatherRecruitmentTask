//
//  WeatherViewModel.swift
//  WeatherRecruitmentTask
//
//  Created by Marcin Bartminski on 12/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherViewModel {
    
    var weatherData: BehaviorRelay<WeatherData?> = BehaviorRelay(value: nil)
    var showAlert: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let network = NetworkManager()
    
    init(cityName: String) {
        Task {
            do {
                let weather = try await network.fetchWeatherDataDeprecated(for: cityName)
                weatherData.accept(weather)
            } catch {
                DispatchQueue.main.async {
                    self.showAlert.accept(true)
                }
                print(error.localizedDescription)
            }
        }
    }
    
    init(lat: Double, lon: Double) {
        Task {
            do {
                let weather = try await network.fetchWeatherData(lat: lat, lon: lon)
                weatherData.accept(weather)
            } catch {
                DispatchQueue.main.async {
                    self.showAlert.accept(true)
                }
                print(error.localizedDescription)
            }
        }
    }
    
    func temperatureString(from kelvin: Double?, to unit: UnitTemperature) -> String {
        guard let kelvin else { return "" }
        
        let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: "US_en")
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        
        let kel = Measurement(value: kelvin, unit: UnitTemperature.kelvin)
        let out = kel.converted(to: unit)
        
        return formatter.string(from: out)
    }
    
    func icon(for code: Int) -> UIImage? {
        return UIImage(systemName: iconName(for: code))
    }
    
    private func iconName(for code: Int) -> String {
        switch code {
        case 200 ..< 300:
            return "cloud.bolt.rain.fill"
        case 300 ..< 400:
            return "cloud.drizzle.fill"
        case 500 ..< 600:
            return "cloud.rain.fill"
        case 600 ..< 700:
            return "cloud.snow.fill"
        case 700 ..< 800:
            return "sun.haze.fill"
        case 800:
            return "sun.max.fill"
        case 801 ..< 900:
            return "cloud.fill"
        default:
            return ""
        }
    }
    
}

extension Double {
    func toString() -> String { "\(self)" }
    func percentString() -> String { "\(self.toString())%" }
}
extension Int {
    func toString() -> String { "\(self)" }
    func percentString() -> String { "\(self.toString())%" }
    
    func toTimeOfDay(_ timezone: Int = 0) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: Double(self) + Double(timezone))
        return dateFormatter.string(from: date)
    }
}
