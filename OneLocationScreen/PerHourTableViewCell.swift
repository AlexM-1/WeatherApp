//
//  PerHourTableViewCell.swift
//  WeatherApp
//
//  Created by Alex M on 13.01.2023.
//

import UIKit


class PerHourTableViewCell: UITableViewCell {

    var location: Location!

    var action: (()->Void)?

      var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PerHourCollectionViewCell.self, forCellWithReuseIdentifier: PerHourCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private lazy var detailedButton = CustomButton(
        title: "Подробнее на 24 часа",
        titleColor: UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1),
        font: UIFont(name: "Rubik-Regular", size: 16),
        backgroundColor: .systemBackground) {
            self.action?()
        }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    func setupCell(location: Location) {
        self.location = location
    }

    private func layout() {

        let font = UIFont(name: "Rubik-Regular", size: 16)
        let attributedText = NSAttributedString(string: "Подробнее на 24 часа", attributes:[
            NSAttributedString.Key.font: font ?? UIFont(),
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ])

        detailedButton.setAttributedTitle(attributedText, for: .normal)
        [detailedButton, collectionView].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([

            detailedButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            detailedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            detailedButton.heightAnchor.constraint(equalToConstant: 20),

            collectionView.topAnchor.constraint(equalTo: detailedButton.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),


            contentView.heightAnchor.constraint(equalToConstant: 130),
        ])

    }
}


extension PerHourTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PerHourCollectionViewCell.identifier, for: indexPath) as! PerHourCollectionViewCell
        cell.setupCell(location: location, index: indexPath.row)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 42, height: 83)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }


}
