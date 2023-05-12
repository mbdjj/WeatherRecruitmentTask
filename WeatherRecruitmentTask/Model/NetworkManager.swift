//
//  NetworkManager.swift
//  WeatherRecruitmentTask
//
//  Created by Marcin Bartminski on 12/05/2023.
//

import Foundation

struct NetworkManager {
    
    let apiKey = ""
    
    func fetchWeatherData(for city: String) async throws -> WeatherData {
        let cityURLFriendly = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(cityURLFriendly)&limit=1&appid=\(apiKey)") else {
            throw CityError.badURL
        }
        
        print(url.absoluteString)
        
        let req = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw CityError.badResponseCode
        }
        
        do {
            let decoder = JSONDecoder()
            let cityData = try decoder.decode([CityData].self, from: data)
            
            print("Fetched city data for \(cityData[0].name)")
            
            return try await fetchWeatherData(lat: cityData[0].lat, lon: cityData[0].lon)
        } catch {
            print("Couldn't decode city data received")
            throw CityError.decodingError
        }
    }
    
    func fetchWeatherData(lat: Double, lon: Double) async throws -> WeatherData {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") else {
            throw WeatherError.badURL
        }
        
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            let response = response as! HTTPURLResponse
            print("Invalid response code: \(response.statusCode)")
            throw WeatherError.badResponseCode
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            
            print("Fetched weather data for \(weatherData.name)")
            
            return weatherData
        } catch {
            print("Couldn't decode weather data received")
            throw WeatherError.decodingError
        }
    }
    
    
    func fetchWeatherDataDeprecated(for city: String) async throws -> WeatherData {
        let cityURLFriendly = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityURLFriendly)&appid=\(apiKey)") else {
            throw WeatherError.badURL
        }
        
        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            let response = response as! HTTPURLResponse
            print("Invalid response code: \(response.statusCode)")
            throw WeatherError.badResponseCode
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            
            print("Fetched weather data for \(weatherData.name)")
            
            return weatherData
        } catch {
            print("Couldn't decode weather data received")
            throw WeatherError.decodingError
        }
    }
    
}

enum WeatherError: Error {
    case badURL
    case badResponseCode
    case decodingError
}

enum CityError: Error {
    case badURL
    case badResponseCode
    case decodingError
}
