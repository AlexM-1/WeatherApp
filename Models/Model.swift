//
//  Model.swift
//  WeatherApp
//
//  Created by Alex M on 20.01.2023.
//

import Foundation

final class Model {
    
    static func reloadLocation(location: Location, completion: @escaping (()->Void)) {
        
        NetworkManager().download(location: location) { weatherResponse in
            if weatherResponse != nil,
               let forecastsCodable = weatherResponse?.forecasts {
                
                CoreDataManager.default.deleteForecasts(location: location)
                
                CoreDataManager.default.reloadForecasts(in: location, forecastsCodable: forecastsCodable) {

                    completion()
                }
                
                CoreDataManager.default.reloadDailyFact(in: location, with: weatherResponse) {
                    completion()
                }
                
                completion()
            }
        }
    }
    
    
    static func getLocationCoordinate(completion: @escaping ()->Void ) {
        
        if let coordinate2D = LocationAuthorization().getLocationCoordinate2D() {
            
            Geocode().geocodeСoordinates(latitude: coordinate2D.latitude, longitude: coordinate2D.longitude) { placemark, error in
                
                guard let place = placemark?.first,
                      let location = placemark?.first?.location else {
                    return }
                
                let foundLocation = FoundLocation(latitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  city: (place.locality ?? "") + " - текущее местоположение",
                                                  country: place.country ?? "",
                                                  administrativeArea: place.administrativeArea ?? "")
                
                CoreDataManager.default.addLocation(location: foundLocation)
                completion()
                
            }
        }
    }
    
    
}
