//
//  StringExtension.swift
//  WeatherApp
//
//  Created by Alex M on 03.01.2023.
//

import Foundation


extension String {
    var firstUppercased: String {
        let firstChar = self.first?.uppercased() ?? ""
        return firstChar + self.dropFirst()
    }
}
