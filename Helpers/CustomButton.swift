//
//  CustomButton.swift
//  WeatherApp
//
//  Created by Alex M on 29.12.2022.
//

import UIKit

class CustomButton: UIButton {

    private var buttonTappedAction: (() -> Void)?

    init(title: String,
         titleColor: UIColor,
         font: UIFont?,
         backgroundColor: UIColor?,
         image: UIImage? = nil,
         imagePadding: CGFloat = 0,
         buttonTappedAction: (() -> Void)?) {

        super.init(frame: .zero)

        self.buttonTappedAction = buttonTappedAction


        var configuration = UIButton.Configuration.filled()
        configuration.background.backgroundColor = backgroundColor
        configuration.image = image
        configuration.imagePadding = imagePadding

        self.configuration = configuration

        translatesAutoresizingMaskIntoConstraints = false

        let attributedText = NSAttributedString(string: title, attributes:[
            NSAttributedString.Key.font: font ?? UIFont(),
            NSAttributedString.Key.foregroundColor: titleColor])
        self.setAttributedTitle(attributedText, for: .normal)

        layer.cornerRadius = 10
        layer.masksToBounds = true

        configurationUpdateHandler = { button in
            switch button.state {
            case .normal:
                button.alpha = 1.0
            case .selected, .highlighted, .disabled:
                button.alpha = 0.6
            default:
                button.alpha = 0.6
            }
        }
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonTapped() {
        buttonTappedAction?()
    }
    
}

