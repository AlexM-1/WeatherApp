//
//  EmptyVC.swift
//  WeatherApp
//
//  Created by Alex M on 30.12.2022.
//

import UIKit

class EmptyVC: UIViewController {


    var closure: (()->Void)?

    private lazy var addCityButton = CustomButton (
        title: "+",
        titleColor: .white,
        font: UIFont(name: "Rubik-Medium", size: 120),
        backgroundColor: UIColor(named: "orange")) {

            let vc = AddCityVC()
            vc.closure = self.closure
            vc.modalPresentationStyle = .automatic
            let nc = UINavigationController(rootViewController: vc)
            self.present(nc, animated: true)
        }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        title = "Локации не заданы"

        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        setupView()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if navigationController?.isBeingDismissed == true {
            closure?()
        }
    }

    private func createViewConstraint() {
        NSLayoutConstraint.activate([

            addCityButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addCityButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            addCityButton.heightAnchor.constraint(equalToConstant: 120),
            addCityButton.widthAnchor.constraint(equalToConstant: 120),

        ])


    }

    private func setupView() {
        view.addSubview(addCityButton)
        createViewConstraint()
    }

}



