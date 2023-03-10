//
//  SettingsVC.swift
//  WeatherApp
//
//  Created by Alex M on 11.01.2023.
//

import UIKit



final class SettingsVC: UIViewController, UITableViewDataSource {


    private var model = SettingsModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
      tableView.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)


        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        return tableView
    }()

    private lazy var setButton = CustomButton (title: model.titleButton,
                                               titleColor: .white,
                                               font: UIFont(name: "Rubik-Regular", size: 16),
                                               backgroundColor: UIColor(named: "orange")) {
        
        self.model.saveModel()
            self.navigationController?.popViewController(animated: true)

    }

    private lazy var titleLabel = CustomLabel (
        titleColor: UIColor(red: 0.153, green: 0.153, blue: 0.133, alpha: 1),
        font: UIFont(name: "Rubik-Medium", size: 18),
        title: self.model.title)


    private lazy var mainView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "settingsBG"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var settingsView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(red: 0.914, green: 0.933, blue: 0.98, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(false)
            self.navigationController?.isNavigationBarHidden = true
    }

    private func setupView() {
        [mainView, settingsView, titleLabel, setButton, tableView].forEach {
            view.addSubview($0)
        }
        createViewConstraint()
    }

    private func createViewConstraint() {
        NSLayoutConstraint.activate([

            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            settingsView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),

            settingsView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 28),
            settingsView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -28),
            settingsView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 46),

            tableView.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 47),
            tableView.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -83),

            titleLabel.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 27),
            titleLabel.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 20),

            setButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 35),
            setButton.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -35),
            setButton.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -16),
            setButton.heightAnchor.constraint(equalToConstant: 40),

        ])
    }



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.menu.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as! SettingsCell

        let menuModel = model.menu[indexPath.row]
        cell.setupCell(menuModel: menuModel) { target in
            self.model.menu[indexPath.row].selectedSegmentIndex = target.selectedSegmentIndex
        }
        return cell
    }
}
