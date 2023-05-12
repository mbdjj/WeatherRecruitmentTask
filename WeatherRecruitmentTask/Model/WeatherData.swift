//
//  WeatherData.swift
//  WeatherRecruitmentTask
//
//  Created by Marcin Bartminski on 12/05/2023.
//

import Foundation

struct WeatherData: Decodable {
    let coord: WeatherCoord
    let weather: [WeatherWeather]
    let main: WeatherMain
    let clouds: WeatherClouds
    let sys: WeatherSys
    let timezone: Int
    let name: String
    
//    static let dummy = WeatherData(
//        coord: WeatherCoord(lon: 0.0, lat: 0.0),
//        weather: [WeatherWeather(id: 800, main: "Clear")],
//        main: WeatherMain(temp: 291, tempMin: 290, tempMax: 292),
//        clouds: WeatherClouds(all: 0),
//        sys: WeatherSys(sunrise: 1683860535, sunset: 1683916512),
//        name: "---"
//    )
}

struct WeatherCoord: Decodable {
    let lon: Double
    let lat: Double
}

struct WeatherWeather: Decodable {
    let id: Int
    let main: String
}

struct WeatherMain: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
}

struct WeatherClouds: Decodable {
    let all: Int
}

struct WeatherSys: Decodable {
    let sunrise: Int
    let sunset: Int
}
