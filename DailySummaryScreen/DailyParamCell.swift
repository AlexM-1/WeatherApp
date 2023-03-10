//
//  DailyParamCell.swift
//  WeatherApp
//
//  Created by Alex M on 19.01.2023.
//


import UIKit

final class DailyParamCell: UITableViewCell {
    
    private let valueLabel = CustomLabel(
        titleColor: .black,
        font: UIFont(name: "Rubik-Regular", size: 18))
    
    private let paramLabel = CustomLabel(
        titleColor: .black,
        font: UIFont(name: "Rubik-Regular", size: 16))
    
    
    private var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupCell (index: Int, forecast: Forecast) {
        
        let tempFeelsLike = MeasurementConverter.default.getTempWithSettings(from: forecast.tempFeelsLike)
        
        var windDir = ""
        if let key = forecast.windDir,
           let value = windDirection[key] {
            windDir = value
        }
        
        let windSpeed = MeasurementConverter.default.getWindSpeedWithSettings(from: Int16(forecast.windSpeed))
        let wind = "\(windDir), \(windSpeed)"
        
        
        let paramValue = [
            tempFeelsLike,
            wind,
            "\(forecast.humidity)%",
            "\(forecast.precProb)%",
            "\(forecast.pressureValue)",
            "\(cloudness[Int(forecast.cloudness*100)] ?? "")"
        ]
        
        let paramName = [
            "По ощущениям",
            "Ветер",
            "Влажность",
            "Осадки - \(precType[Int(forecast.precType)] ?? "")",
            "Давление, мм рт. ст.",
            "Облачность",
        ]
        
        let paramIcon = [
            "iconFeelsLike",
            "windIcon",
            "humidityIcon",
            "precIcon",
            "pressureIcon",
            "cloudness",
        ]
        
        valueLabel.text = "\(paramValue[index])"
        paramLabel.text = "\(paramName[index])"
        icon.image = UIImage(named: paramIcon[index])
    }
    
    
    
    
    private func layout() {
        
        [valueLabel, paramLabel, icon].forEach { contentView.addSubview($0) }
        valueLabel.numberOfLines = 2
        valueLabel.textAlignment = .right
        contentView.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        
        NSLayoutConstraint.activate([
            
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLabel.widthAnchor.constraint(equalToConstant: 180),
            
            paramLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            paramLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 54),
            
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            icon.heightAnchor.constraint(equalToConstant: 30),
            icon.widthAnchor.constraint(equalToConstant: 35),
        ])
    }
}

