//
//  TextPicker.swift
//  WeatherApp
//
//  Created by Alex M on 29.12.2022.
//


//import UIKit
//
//class TextPicker {
//
//    static let `default` = TextPicker()
//
//
//    func getText(showIn viewController: UIViewController, completion: ((_ text: String)->Void)?) {
//        let alertController = UIAlertController(title: "Добавить метку", message: nil, preferredStyle: .alert)
//        alertController.addTextField { textField in
//            textField.placeholder = "Название"
//        }
//
//        let actionAdd = UIAlertAction(title: "Сохранить", style: .default) { action in
//            if let text = alertController.textFields?[0].text,
//               text != "" {
//                completion?(text)
//            }
//        }
//        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel)
//
//        alertController.addAction(actionAdd)
//        alertController.addAction(actionCancel)
//
//        viewController.present(alertController, animated: true)
//    }
//
//    func showInfo(showIn viewController: UIViewController, title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let actionCancel = UIAlertAction(title: "ОК", style: .cancel)
//        alertController.addAction(actionCancel)
//        viewController.present(alertController, animated: true)
//    }
//
//
//    func checkAction(showIn viewController: UIViewController,
//                     title1: String,
//                     title2: String,
//                     completion1: (()->Void)?,
//                     completion2: (()->Void)?) {
//
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
//        let action1 = UIAlertAction(title: title1, style: .default) {_ in
//            completion1?()
//        }
//        let action2 = UIAlertAction(title: title2, style: .default)
//        {_ in
//            completion2?()
//        }
//
//        let actionCancel = UIAlertAction(title: "Отменить", style: .cancel)
//        [action1, action2, actionCancel].forEach {
//            alertController.addAction($0)
//        }
//
//        viewController.present(alertController, animated: true)
//    }
//
//}
