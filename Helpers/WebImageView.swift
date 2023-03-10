//
//  WebImageView.swift
//  WeatherApp
//
//  Created by Alex M on 09.03.2023.
//

import Foundation
import UIKit

// Класс для работы с изображениями SVG, полученными из API

final class WebImageView: UIImageView {
    
    func set(imageUrl: String?) {
        NetworkManager.downloadImage(from: imageUrl) { response in
            if response.status
            {
                DispatchQueue.main.async {
                    self.image = response.image
                }
            }
        }
    }
    
}

