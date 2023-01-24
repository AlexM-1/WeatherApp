//
//  SettingsModel.swift
//  WeatherApp
//
//  Created by Alex M on 12.01.2023.
//

import UIKit
import Foundation

protocol MenuModelProtocol {
    var title: String  { get }
    var valueArray: [String] { get }
    var selectedSegmentIndex: Int { get set }
}


struct MenuModel: MenuModelProtocol {
    let title: String
    let valueArray: [String]
    var selectedSegmentIndex: Int
}


final class SettingsModel {

    var title: String = "Настройки"
    var titleButton: String = "Установить"


    var menu: [MenuModel] = [
        MenuModel(title: "Температура", valueArray: ["C", "F"], selectedSegmentIndex: 0),
        MenuModel(title: "Скорость ветра", valueArray: ["Mi", "Km"], selectedSegmentIndex: 1),
        MenuModel(title: "Формат времени", valueArray: ["12", "24"], selectedSegmentIndex: 1),
        MenuModel(title: "Уведомления", valueArray: ["On", "Off"], selectedSegmentIndex: 0),
    ]

    init() {
        let settingsIsSaved = UserDefaults.standard.bool(forKey: "settingsIsSaved")
        if settingsIsSaved {
            loadModel()
        } else {
            saveModel()
            UserDefaults.standard.set(true, forKey: "settingsIsSaved")
        }
    }


    func loadModel() {
        for (index, menuModel) in menu.enumerated() {
            menu[index].selectedSegmentIndex  = UserDefaults.standard.integer(forKey: menuModel.title)
        }
    }


    func saveModel() {
        menu.forEach { menuModel in
            UserDefaults.standard.set(menuModel.selectedSegmentIndex, forKey: menuModel.title)
            UserDefaults.standard.synchronize()
        }
    }
}
