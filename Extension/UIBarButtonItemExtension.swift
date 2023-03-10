//
//  UIBarButtonItemExtension.swift
//  WeatherApp
//
//  Created by Alex M on 30.12.2022.
//

import UIKit

extension UIBarButtonItem {

    static func menuButton(_ target: Any?,
                           action: Selector,
                           imageName: String,
                           size:CGSize = CGSize(width: 32, height: 32),
                           tintColor:UIColor?) -> UIBarButtonItem
    {
        let button = UIButton(type: .system)
        button.tintColor = tintColor
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: size.width).isActive = true

        return menuBarItem
    }
}

