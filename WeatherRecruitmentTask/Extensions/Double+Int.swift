//
//  Double+Int.swift
//  WeatherRecruitmentTask
//
//  Created by Marcin Bartminski on 25/05/2023.
//

import Foundation

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
