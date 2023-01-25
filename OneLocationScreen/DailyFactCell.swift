//
//  DailyFactCell.swift
//  WeatherApp
//
//  Created by Alex M on 04.01.2023.
//


import UIKit

class DailyFactCell: UITableViewCell {

    private let contentMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(named: "mainBlue")
        return view
    }()


    private let timeUpdateLabel = CustomLabel(
        titleColor: UIColor(red: 0.965, green: 0.867, blue: 0.004, alpha: 1),
        font: UIFont(name: "Rubik-Regular", size: 16))


    private let sunriseLabel = CustomLabel(
        titleColor: .white,
        font: UIFont(name: "Rubik-Medium", size: 14))


    private let sunsetLabel = CustomLabel(
        titleColor: .white,
        font: UIFont(name: "Rubik-Medium", size: 14))


    private let conditionLabel = CustomLabel(
        titleColor: .white,
        font: UIFont(name: "Rubik-Regular", size: 16))


    private let tempLabel = CustomLabel(
        titleColor: .white,
        font: UIFont(name: "Rubik-Medium", size: 36))


    private let tempMinMaxLabel = CustomLabel(
        titleColor: .white,
        font: UIFont(name: "Rubik-Regular", size: 16))

    private let windLabel = CustomLabel(
        titleColor: .white,
        font: UIFont(name: "Rubik-Regular", size: 14))

    private let humidityLabel = CustomLabel(
        titleColor: .white,
        font: UIFont(name: "Rubik-Regular", size: 14))


    private let precLabel = CustomLabel(
        titleColor: .white,
        font: UIFont(name: "Rubik-Regular", size: 14))


    private var windIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "windIconWhite"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    private var humidityIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "humidityIconWhite"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    private var sunriseIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sunrise"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    private var sunsetIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sunset"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    private var conditionIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    private var ellipseView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ellipse"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setupCell(location: Location) {

        if let fact = location.dailyFact {
            sunriseLabel.text = MeasurementConverter.default.getTimeWithSettings(from: fact.sunrise)
            sunsetLabel.text = MeasurementConverter.default.getTimeWithSettings(from: fact.sunset)
            timeUpdateLabel.text = MeasurementConverter.default.getDateWithSettings(from: fact.uptime)
            tempLabel.text = MeasurementConverter.default.getTempWithSettings(from: fact.tempNow)

            if let status = fact.condition,
               let condition = conditions[status] {
                conditionLabel.text = condition.firstUppercased
            }

            tempMinMaxLabel.text = MeasurementConverter.default.getTempWithSettings(from: fact.tempMin) + "/" + MeasurementConverter.default.getTempWithSettings(from: fact.tempMax)
            windLabel.text = MeasurementConverter.default.getWindSpeedWithSettings(from: fact.windSpeed)
            humidityLabel.text = "\(fact.humidity) %"
            precLabel.text = "\(fact.precProb) %"

            if let pngData = fact.conditionIcon {
                conditionIcon.image = UIImage(data: pngData)
            }
        }
    }



    private func layout() {

        [contentMainView,
         ellipseView,
         timeUpdateLabel,
         sunriseLabel,
         sunsetLabel,
         sunriseIcon,
         sunsetIcon,
         conditionLabel,
         precLabel,
         tempLabel,
         tempMinMaxLabel,
         windIcon,
         windLabel,
         humidityIcon,
         humidityLabel,
         conditionIcon

        ].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            contentMainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            contentMainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            contentMainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            contentMainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),


            ellipseView.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 17),
            ellipseView.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 32),
            ellipseView.trailingAnchor.constraint(equalTo: contentMainView.trailingAnchor, constant: -32),


            timeUpdateLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 171),
            timeUpdateLabel.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 97),
            timeUpdateLabel.trailingAnchor.constraint(equalTo: contentMainView.trailingAnchor, constant: -97),


            sunriseLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 167),
            sunriseLabel.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 17),
            sunriseLabel.bottomAnchor.constraint(equalTo: contentMainView.bottomAnchor, constant: -26),


            sunsetLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 167),
            sunsetLabel.trailingAnchor.constraint(equalTo: contentMainView.trailingAnchor, constant: -17),
            sunsetLabel.bottomAnchor.constraint(equalTo: contentMainView.bottomAnchor, constant: -26),


            sunriseIcon.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 145),
            sunriseIcon.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 25),
            sunriseIcon.heightAnchor.constraint(equalToConstant: 17),
            sunriseIcon.widthAnchor.constraint(equalToConstant: 17),


            sunsetIcon.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 145),
            sunsetIcon.trailingAnchor.constraint(equalTo: contentMainView.trailingAnchor, constant: -25),
            sunsetIcon.heightAnchor.constraint(equalToConstant: 17),
            sunsetIcon.widthAnchor.constraint(equalToConstant: 17),


            conditionLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 103),
            conditionLabel.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 58),
            conditionLabel.trailingAnchor.constraint(equalTo: contentMainView.trailingAnchor, constant: -58),


            precLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 138),
            precLabel.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 103),


            tempLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 58),
            tempLabel.centerXAnchor.constraint(equalTo: contentMainView.centerXAnchor),


            tempMinMaxLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 33),
            tempMinMaxLabel.centerXAnchor.constraint(equalTo: contentMainView.centerXAnchor),


            windIcon.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 138),
            windIcon.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 141),
            windIcon.heightAnchor.constraint(equalToConstant: 16),
            windIcon.widthAnchor.constraint(equalToConstant: 25),


            windLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 138),
            windLabel.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 169),


            humidityIcon.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 139),
            humidityIcon.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 216),
            humidityIcon.heightAnchor.constraint(equalToConstant: 15),
            humidityIcon.widthAnchor.constraint(equalToConstant: 13),


            humidityLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 138),
            humidityLabel.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 234),


            conditionIcon.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 134),
            conditionIcon.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 78),
            conditionIcon.heightAnchor.constraint(equalToConstant: 25),
            conditionIcon.widthAnchor.constraint(equalToConstant: 25),

        ])
    }
}
