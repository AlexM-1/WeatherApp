//
//  CustomLabel.swift
//  WeatherApp
//
//  Created by Alex M on 04.01.2023.
//

import UIKit

class CustomLabel: UILabel {
    
    
    init(titleColor: UIColor, font: UIFont?, title: String = "") {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        self.numberOfLines = 1
        self.text = title
        self.textColor = titleColor
        self.textAlignment = .center

    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


