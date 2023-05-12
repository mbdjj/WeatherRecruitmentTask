//
//  CityData.swift
//  WeatherRecruitmentTask
//
//  Created by Marcin Bartminski on 12/05/2023.
//

import Foundation

struct CityData: Decodable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
}
