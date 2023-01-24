//
//  DailySummaryCell.swift
//  WeatherApp
//
//  Created by Alex M on 17.01.2023.
//

import UIKit

final class DailySummaryCell: UITableViewCell {
    
    var forecast: Forecast!
    
    private let contentMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        return view
    }()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DailyParamCell.self, forCellReuseIdentifier: DailyParamCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1)
        tableView.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.sectionHeaderHeight = 0.01
        return tableView
    }()
    
    
    private let partOfDayLabel = CustomLabel(
        titleColor: UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1),
        font: UIFont(name: "Rubik-Regular", size: 18))
    
    
    private var conditionIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private let tempLabel = CustomLabel(
        titleColor: UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1),
        font: UIFont(name: "Rubik-Regular", size: 30))
    
    
    private let conditionLabel = CustomLabel(
        titleColor: UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1),
        font: UIFont(name: "Rubik-Medium", size: 18))
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupCell(forecast: Forecast) {
        
        if let key = forecast.partName,
           let value = partOfDay[key] {
            partOfDayLabel.text = value.firstUppercased
        }
        
        tempLabel.text = MeasurementConverter.default.getTempWithSettings(from: forecast.tempAvg)
        
        if let key = forecast.condition,
           let value = conditions[key] {
            conditionLabel.text = value.firstUppercased
        }
        
        if let pngData = forecast.conditionIcon {
            conditionIcon.image = UIImage(data: pngData)
        }
        self.tableView.reloadData()
    }
    
    
    
    
    private func layout() {
        
        [contentMainView,
         tableView,
         partOfDayLabel,
         conditionIcon,
         tempLabel,
         conditionLabel].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            contentMainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            contentMainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            contentMainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            contentMainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            partOfDayLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 21),
            partOfDayLabel.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 15),
            
            conditionLabel.centerXAnchor.constraint(equalTo: contentMainView.centerXAnchor),
            conditionLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 62),
            
            conditionIcon.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 15),
            conditionIcon.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor, constant: 130),
            conditionIcon.heightAnchor.constraint(equalToConstant: 42),
            conditionIcon.widthAnchor.constraint(equalToConstant: 42),
            
            tempLabel.leadingAnchor.constraint(equalTo: conditionIcon.trailingAnchor, constant: 10),
            tempLabel.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 15),
            
            tableView.topAnchor.constraint(equalTo: contentMainView.topAnchor, constant: 99),
            tableView.leadingAnchor.constraint(equalTo: contentMainView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentMainView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentMainView.bottomAnchor, constant: -12),
            
        ])
    }
    
}



extension DailySummaryCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyParamCell.identifier, for: indexPath) as! DailyParamCell
        cell.setupCell(index: indexPath.row, forecast:forecast)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.01
    }
    
}

