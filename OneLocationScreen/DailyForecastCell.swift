//
//  DailyForecastCell.swift
//  WeatherApp
//
//  Created by Alex M on 30.12.2022.
//

import UIKit
import CoreData

class DailyForecastCell: UITableViewCell {


    private let contentMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(named: "backGroundCell")
        return view
    }()


    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Regular", size: 16)
        label.numberOfLines = 1
        label.textColor = UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1)
        return label
    }()


    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Regular", size: 16)
        label.numberOfLines = 2
        label.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        return label
    }()


    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Regular", size: 12)
        label.numberOfLines = 1
        label.textColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        return label
    }()


    private let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Rubik-Regular", size: 18)
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()


    private var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setupCell(forecast: Forecast) {

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = df.date(from: forecast.date ?? "")
        df.dateFormat = "dd/MM"
        dateLabel.text = df.string(from: date ?? Date())

        humidityLabel.text = String(forecast.humidity) + "%"
        if let key = forecast.condition,
               let value = conditions[key] {
                conditionLabel.text = value.firstUppercased
            }

        tempLabel.text = MeasurementConverter.default.getTempWithSettings(from: forecast.tempMin) + " ... " + MeasurementConverter.default.getTempWithSettings(from: forecast.tempMax) + " >"

            if let pngData = forecast.conditionIcon {
                iconView.image = UIImage(data: pngData)
            }

    }



    private func layout() {

        [contentMainView,
         dateLabel,
         conditionLabel,
         iconView,
         humidityLabel,
         tempLabel].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            contentMainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            contentMainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            contentMainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            contentMainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            dateLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: contentMainView.bottomAnchor, constant: -31),

            conditionLabel.centerYAnchor.constraint(equalTo: contentMainView.centerYAnchor),
            conditionLabel.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 66),
            conditionLabel.trailingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: -112),

            iconView.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 30),
            iconView.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 10),
            iconView.heightAnchor.constraint(equalToConstant: 17),
            iconView.widthAnchor.constraint(equalToConstant: 17),

            humidityLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            humidityLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 5),

            tempLabel.centerYAnchor.constraint(equalTo: contentMainView.centerYAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: contentMainView.trailingAnchor, constant: -17),

        ])

    }

    
}
