//
//  DailySummaryCollectionCell.swift
//  WeatherApp
//
//  Created by Alex M on 18.01.2023.
//

import UIKit

class DailySummaryCollectionCell: UICollectionViewCell {


    private let dataLabel = CustomLabel(
        titleColor: .white,
        font: UIFont(name: "Rubik-Regular", size: 18))


    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1) : .white
            self.dataLabel.textColor = isSelected ? .white : .black
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(data: String) {

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = df.date(from: data)
        df.dateFormat = "dd/MM E"
        df.locale = Locale(identifier: "ru_RU")
        dataLabel.text = df.string(from: date ?? Date())
    }

    private func layout() {

        contentView.backgroundColor = .white
        dataLabel.textColor = .black

        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.addSubview(dataLabel)


        NSLayoutConstraint.activate([
            dataLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dataLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

        ])
    }

}

