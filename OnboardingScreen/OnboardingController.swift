//
//  ViewController.swift
//  WeatherApp
//
//  Created by Alex M on 28.12.2022.
//

import UIKit
import CoreLocation

final class OnboardingController: UIViewController, CLLocationManagerDelegate {

    private let viewModel: OnboardingViewModel

    private var locationManager = CLLocationManager()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    
    private lazy var onBoardingImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "onBoardingImage"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var primaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.973, green: 0.961, blue: 0.961, alpha: 1)
        label.font = UIFont(name: "Rubik-SemiBold", size: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = "Разрешить приложению  WeatherApp использовать данные \nо местоположении вашего устройства"
        return label
    }()
    
    private lazy var secondaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "Rubik-Regular", size: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = "Чтобы получить более точные прогнозы погоды во время движения или путешествия"
        return label
    }()
    
    private lazy var thirdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Rubik-Regular", size: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = "Вы можете изменить свой выбор в любое время из меню приложения"
        return label
    }()
    
    

    
    private lazy var useGeoButton = CustomButton (title: "ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ  УСТРОЙСТВА",
                                                  titleColor: .white,
                                                  font: UIFont(name: "Rubik-Medium", size: 12),
                                                  backgroundColor: UIColor(named: "orange")) {

        self.locationManager.requestWhenInUseAuthorization()
    }
    
    

    private lazy var dismissUseGeoButton = CustomButton (title: "НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ",
                                                         titleColor: .white,
                                                         font: UIFont(name: "Rubik-Regular", size: 16),
                                                         backgroundColor: UIColor(named: "mainBlue")) {

        self.viewModel.changeState(.dismissUseGeo)
    }
    

    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self

        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor(named: "mainBlue")
        
        setupView()
        layout()
    }
    
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [onBoardingImage,
         primaryLabel,
         secondaryLabel,
         thirdLabel,
         useGeoButton,
         dismissUseGeoButton].forEach { contentView.addSubview($0) }
    }
    
    
    private func layout() {
        
        
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),


            onBoardingImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 148),
            onBoardingImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 21),
            onBoardingImage.heightAnchor.constraint(equalToConstant: 196),
            onBoardingImage.widthAnchor.constraint(equalToConstant: 180),
            
            primaryLabel.topAnchor.constraint(equalTo: onBoardingImage.bottomAnchor, constant: 56),
            primaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            primaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            
            secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: 56),
            secondaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            secondaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            thirdLabel.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: 14),
            thirdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            thirdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            useGeoButton.topAnchor.constraint(equalTo: thirdLabel.bottomAnchor, constant: 44),
            useGeoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            useGeoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            useGeoButton.heightAnchor.constraint(equalToConstant: 40),

            dismissUseGeoButton.topAnchor.constraint(equalTo: useGeoButton.bottomAnchor, constant: 12),
            dismissUseGeoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            dismissUseGeoButton.heightAnchor.constraint(equalToConstant: 40),
            dismissUseGeoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
            
        ])
        
    }




    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        switch manager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            self.viewModel.changeState(.useGeo)
            break
        case .notDetermined , .denied , .restricted:
            self.viewModel.changeState(.dismissUseGeo)
        default:
            break
        }
    }
    
    
}

