//
//  MeasurementConverter.swift
//  WeatherApp
//
//  Created by Alex M on 17.01.2023.
//

import Foundation


final class MeasurementConverter {
    
    private var settingsModel = SettingsModel()
    
    static let `default` = MeasurementConverter()
    
    
    func getTempWithSettings(from value: Int16) -> String {
        
        var converted = value
        
        if UserDefaults.standard.integer(forKey: "Температура") == 1 {
            let meas = Measurement(value: Double(value), unit: UnitTemperature.celsius)
            converted = Int16(meas.converted(to: UnitTemperature.fahrenheit).value)
        }
        
        let signTemp = converted > 0 ? "+" : ""
        return "\(signTemp)\(converted)°"
    }
    
    
    func getWindSpeedWithSettings(from value: Int16) -> String {
        
        if UserDefaults.standard.integer(forKey: "Скорость ветра") == 0 {
            let meas = Measurement(value: Double(value), unit: UnitSpeed.metersPerSecond)
            let converted = Int16(meas.converted(to: UnitSpeed.milesPerHour).value)
            
            return "\(converted) mph"
            
        } else {
            return "\(value) м/с"
            
        }
        
    }
    
    
    func getDateWithSettings(from date: Date?) -> String {
        
        guard let date = date else { return "" }
        
        let df = DateFormatter()
        
        if UserDefaults.standard.integer(forKey: "Формат времени") == 1 {
            df.locale = Locale(identifier: "ru_RU")
            df.dateFormat = "HH:mm, E d MMMM"
        } else {
            df.locale = Locale(identifier: "en_US_POSIX")
            df.dateFormat = "h:mm a, E d MMM"
        }
        return df.string(from: date)
    }
    
    
    func getTimeWithSettings(from dateStr: String?, showMinutes: Bool = true) -> String {
        
        guard let dateStr = dateStr else { return "" }
        
        if UserDefaults.standard.integer(forKey: "Формат времени") == 0 {
            
            let df = DateFormatter()
            df.dateFormat = "HH:mm"
            let date = df.date(from: dateStr)
            if showMinutes {
                df.dateFormat = "h:mm a"
            } else {
                df.dateFormat = "h a"
            }
            df.locale = Locale(identifier: "en_US_POSIX")
            guard let date = date else { return "" }
            
            return df.string(from: date)
        } else {
            
            return dateStr
        }
    }
    
}
