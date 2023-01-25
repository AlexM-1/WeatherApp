//
//  Weather.swift
//  WeatherApp
//
//  Created by Alex M on 03.01.2023.
//

import Foundation

public var weather: [WeatherResponseCodable] = []
public var forecasts: [ForecastsCodable] = []

public struct FactCodable: Codable {
    public let temp: Int
    public let icon: String
    public let feels_like: Double
    public let pressure_mm: Double
    public let humidity: Int
    public let condition: String
    public let prec_prob: Double
    public let wind_speed: Double
    public let uptime: Date

}


public struct PartOfDayCodable: Codable {
    public let condition: String
    public let cloudness: Double
    public let feels_like: Int
    public let humidity: Int
    public let icon: String
    public let pressure_mm: Double
    public let prec_mm: Double
    public let prec_prob: Int
    public let prec_type: Int
    public let prec_strength: Double

    public let temp_max: Int
    public let temp_min: Int
    public let temp_avg: Int
    public let wind_dir: String
    public let wind_gust: Double
    public let wind_speed: Double

}

public struct PartsCodable: Codable {
    public let day: PartOfDayCodable
    public let evening: PartOfDayCodable
    public let morning: PartOfDayCodable
    public let night: PartOfDayCodable

}


public struct ForecastsCodable: Codable {
    public let date: String
    public let parts: PartsCodable
    public let sunrise: String
    public let sunset: String
}


public struct WeatherResponseCodable: Codable {
    public let fact: FactCodable
    public let forecasts: [ForecastsCodable]
    public let now_dt: String
}


let conditions: [String:String] = [

    "clear": "ясно",
    "partly-cloudy": "малооблачно",
    "cloudy" :"облачно с прояснениями",
    "overcast" : "пасмурно",
    "drizzle" : "морось",
    "light-rain" : "небольшой дождь",
    "rain" : "дождь",
    "moderate-rain" : "умеренно сильный дождь",
    "heavy-rain" : "сильный дождь",
    "continuous-heavy-rain" : "длительный сильный дождь",
    "showers" : "ливень",
    "wet-snow" : "дождь со снегом",
    "light-snow" : "небольшой снег",
    "snow" : "снег",
    "snow-showers" : "снегопад",
    "hail" : "град",
    "thunderstorm" : "гроза",
    "thunderstorm-with-rain" : "дождь с грозой",
    "thunderstorm-with-hail" : "гроза с градом",
]

let windDirection: [String:String] = [
    "nw": "северо-западный",
    "n": "северный",
    "ne": "северо-восточный",
    "e": "восточный",
    "se": "юго-восточный",
    "s": "южный",
    "sw": "юго-западный",
    "w": "западный",
    "c": "штиль",
]

let partOfDay: [String:String] = [
    "night": "ночь",
    "morning": "утро",
    "day": "день",
    "evening": "вечер",
]


let precType: [Int:String] = [
    0: "без осадков",
    1: "дождь",
    2: "дождь со снегом",
    3: "снег",
    4: "град",
    ]

let precStrength: [Double:String] = [
    0: "без осадков",
    25: "слабый дождь/снег",
    50: "дождь/снег",
    75: "сильный дождь/снег",
    100: "сильный ливень/очень сильный снег",
    ]


let cloudness: [Int:String] = [
    0: "ясно",
    25: "малооблачно",
    50: "облачно с прояснениями",
    75: "облачно с прояснениями",
    100: "пасмурно",
    ]


func makeIconPath(icon: String?, isDark: Bool = true) -> String {
    guard let icon = icon else { return "" }
    var iconStr = ""
    if isDark {
        iconStr = "https://yastatic.net/weather/i/icons/funky/dark/"
    } else {
        iconStr = "https://yastatic.net/weather/i/icons/funky/light/"
    }
    iconStr += icon
    iconStr += ".svg"
    return iconStr
}


func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
