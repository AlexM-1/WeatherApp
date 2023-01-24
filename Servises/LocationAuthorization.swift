//
//  LocationAuthorization.swift
//  WeatherApp
//
//  Created by Alex M on 10.01.2023.
//

import CoreLocation

final class LocationAuthorization {


    func requestLocationAuthorization() {

        let manager = CLLocationManager()

        let currentStatus = manager.authorizationStatus

        switch currentStatus {

        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .authorizedAlways, .authorizedWhenInUse:
            print(" case .authorizedAlways, .authorizedWhenInUse:")

        case .restricted, .denied:
            print(" case .authorizedAlways, .authorizedWhenInUse:")


        @unknown default:
            fatalError("Не обрабатываемый статус")
        }
    }



    func getLocationCoordinate2D() -> CLLocationCoordinate2D? {

        let manager = CLLocationManager()
        print("authorizationStatus", manager.authorizationStatus.rawValue)

        let coordinates = manager.location?.coordinate
        print("coordinates, \(String(describing: coordinates))")

        return coordinates
    }

}
