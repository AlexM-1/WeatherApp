//
//  PerHourCollectionViewCell.swift
//  WeatherApp
//
//  Created by Alex M on 13.01.2023.
//



import UIKit

class PerHourCollectionViewCell: UICollectionViewCell {
    
    
    private let contentMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor(red: 0.671, green: 0.737, blue: 0.918, alpha: 1).cgColor
        return view
    }()
    
    
    private let tempLabel = CustomLabel(
        titleColor: UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1),
        font: UIFont(name: "Rubik-Regular", size: 16))
    
    
    private let timeLabel = CustomLabel(
        titleColor: UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1),
        font: UIFont(name: "Rubik-Regular", size: 14))
    
    
    private var conditionIcon: WebImageView = {
        let webImageView = WebImageView()
        webImageView.translatesAutoresizingMaskIntoConstraints = false
        return webImageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    
    func setupCell(location: Location, index: Int) {
        
        contentMainView.backgroundColor = .systemBackground
        tempLabel.textColor = .black
        timeLabel.textColor = .black
        
        let date = Date()
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "HH"
        
        if let currentHour = Int(df.string(from: date)) {
            let indexToPaint = currentHour / 3
            
            if index == indexToPaint {
                contentMainView.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
                tempLabel.textColor = .white
                timeLabel.textColor = .white
            }
        }
        
        let timeArray = ["00:00", "03:00",
                         "06:00", "09:00",
                         "12:00", "15:00",
                         "18:00", "21:00"]
        
        timeLabel.text = MeasurementConverter.default.getTimeWithSettings(from:  timeArray[index], showMinutes: false)
        
        if let fact = location.dailyFact {
            
            let tempArray = [fact.nightTemp, fact.nightTemp,
                             fact.morningTemp, fact.morningTemp,
                             fact.dayTemp, fact.dayTemp,
                             fact.eveningTemp, fact.eveningTemp]
            
            let iconDataArray = [fact.nightIcon, fact.nightIcon,
                                 fact.morningIcon, fact.morningIcon,
                                 fact.dayIcon, fact.dayIcon,
                                 fact.eveningIcon, fact.eveningIcon]
            
            tempLabel.text = MeasurementConverter.default.getTempWithSettings(from: tempArray[index])
            
            conditionIcon.set(imageUrl: iconDataArray[index])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layout() {
        
        
        [contentMainView, tempLabel, timeLabel, conditionIcon].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            
            contentMainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentMainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentMainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentMainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 15),
            timeLabel.centerXAnchor.constraint(equalTo: contentMainView.centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 57),
            tempLabel.centerXAnchor.constraint(equalTo: contentMainView.centerXAnchor),
            
            conditionIcon.centerYAnchor.constraint(equalTo: contentMainView.centerYAnchor, constant: 3),
            conditionIcon.centerXAnchor.constraint(equalTo: contentMainView.centerXAnchor),
            conditionIcon.heightAnchor.constraint(equalToConstant: 25),
            conditionIcon.widthAnchor.constraint(equalToConstant: 25),
            
        ])
    }
    
}



