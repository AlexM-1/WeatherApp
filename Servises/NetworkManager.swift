//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Alex M on 30.12.2022.
//


import Foundation
import UIKit
import SVGKit

final class NetworkManager {

    private let keyHeader = "X-Yandex-API-Key"
    private let key = "b7f3fefb-86ba-4884-8cc1-4ed521593619"
    static private var imageCache = NSCache<NSString, UIImage>()

    func download(location: Location,
                  copmletionHandler: ((WeatherResponseCodable?) -> Void)?) {

        let strUrl = "https://api.weather.yandex.ru/v2/forecast?lat=\(location.latitude)&lon=\(location.longitude)&hours=false&extra=true"

        let request = NSMutableURLRequest(url: NSURL(string: strUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.addValue(key, forHTTPHeaderField: keyHeader)

        let session = URLSession.shared

        let task = session.dataTask(with: request as URLRequest) { data, responce, error in
            if let error = error {
                print(error)
                copmletionHandler?(nil)
                return
            }

            guard let data = data else {
                print("data is nil")
                copmletionHandler?(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let weatherCodable = try decoder.decode(WeatherResponseCodable.self, from: data)
                copmletionHandler?(weatherCodable)
                


            } catch let error {
                print(error.localizedDescription)
                copmletionHandler?(nil)
            }
        }
        task.resume()
    }



    static func downloadImage(from URLString: String?, with completion: @escaping (_ response: (status: Bool, image: UIImage? ) ) -> Void) {

        DispatchQueue.global().async {

            guard let url = URL(string: URLString ?? "") else {
                completion((status: false, image: nil))
                return
            }

            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                completion((status: true, image: cachedImage))
            } else {
                let receivedicon = SVGKImage(contentsOf: url)
                guard let image = receivedicon?.uiImage else {
                    completion((status: false, image: nil))
                    return
                }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                completion((status: true, image: image))
            }
        }
    }
}
