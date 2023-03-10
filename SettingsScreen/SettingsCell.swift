//
//  SettingsCell.swift
//  WeatherApp
//
//  Created by Alex M on 12.01.2023.
//


import UIKit


final class SettingsCell: UITableViewCell {

    private var action: ((UISegmentedControl)->Void)?

    private lazy var label = CustomLabel(
        titleColor: UIColor(red: 0.538, green: 0.513, blue: 0.513, alpha: 1),
        font: UIFont(name: "Rubik-Regular", size: 16))

    private lazy var segmentControl: UISegmentedControl = {

        let segmentControl = UISegmentedControl()
        let font = UIFont(name: "Rubik-Regular", size: 16)

        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font: font ?? UIFont(),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ], for: .normal)

        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font: font ?? UIFont(),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)

        segmentControl.backgroundColor = UIColor(red: 0.984, green: 0.933, blue: 0.918, alpha: 1)
        segmentControl.layer.cornerRadius = 5
        segmentControl.layer.masksToBounds = true
        segmentControl.selectedSegmentTintColor = UIColor(named: "mainBlue")
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addTarget(self, action: #selector(selectedValue), for: .valueChanged)
        return segmentControl

    }()



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setupCell(menuModel: MenuModelProtocol, action: ((UISegmentedControl)->Void)?) {
        self.action = action
        label.text = menuModel.title
        contentView.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        segmentControl.removeAllSegments()
        for (index, value) in menuModel.valueArray.enumerated() {
            segmentControl.insertSegment(withTitle: value, at: index, animated: false)
            segmentControl.setWidth(40, forSegmentAt: index)
        }
        segmentControl.selectedSegmentIndex = menuModel.selectedSegmentIndex
    }



    private func layout() {

        [label,segmentControl].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            segmentControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),

            contentView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }


    @objc func selectedValue(target: UISegmentedControl) {
        print("value is changed in cell")
        self.action?(target)
    }
}


