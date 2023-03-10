//
//  Geocode.swift
//  WeatherApp
//
//  Created by Alex M on 05.01.2023.
//

import CoreLocation

public protocol LocationProtocol {
    var latitude: Double {get set}
    var longitude: Double {get set}
    var city: String {get set}
    var country: String {get set}
    var administrativeArea: String {get set}

}

public struct FoundLocation: LocationProtocol {
    public var latitude: Double
    public var longitude: Double
    public var city: String
    public var country: String
    public var administrativeArea: String
}


class Geocode {

    func geocodeСoordinates(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemark, error in
            guard let placemark = placemark, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }



    func geocodeAddressString(addressString: String, complete: @escaping (_ location: LocationProtocol?, _ error: String?) -> Void) {

        let queueUserInteractive = DispatchQueue.global(qos: .userInteractive)
        queueUserInteractive.async {
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(addressString) { placemarks, error in

                if let error = error {
                    complete(nil, "Ошибка выполнения запроса: " + error.localizedDescription)
                    return
                }

                guard let placemark = placemarks?.first,
                      let city = placemark.locality,
                      let location = placemark.location else {
                    complete(nil, "")
                    return }


                let foundLocation = FoundLocation(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    city: city,
                    country: placemark.country ?? "", administrativeArea: placemark.administrativeArea ?? "")
                complete(foundLocation, nil)
            }
        }

    }
}






