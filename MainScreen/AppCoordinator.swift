//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Alex M on 29.12.2022.
//

import UIKit


final class AppCoordinator {


    private var navController: UINavigationController

    init(navController: UINavigationController) {
        self.navController = navController
    }

    
    func startApplication() {

        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            showMainScreen()
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            showOnboardingScreen()
        }
    }

    func showOnboardingScreen() {
        let viewModel = OnboardingViewModel(coordinator: self)
        let controller = OnboardingController(viewModel: viewModel)
        navController.setViewControllers([controller], animated: true)
    }


    func showSettingsScreen() {
        let controller = SettingsVC()
        self.navController.pushViewController(controller, animated: true)
    }



    func showDailySummaryVC(with location: Location, at index: Int) {
        let controller = DailySummaryVC(location: location, index: index)
        self.navController.pushViewController(controller, animated: true)
    }

    func showCityManagementVC() {
        let vc = CityManagementVC()
        vc.modalPresentationStyle = .automatic
        let nc = UINavigationController(rootViewController: vc)
        navController.present(nc, animated: true)
    }




    func showScreenWithGeo() {
        navController.viewControllers.removeLast()
        Model.getLocationCoordinate {
            self.showMainScreen()
        }
    }


    func showScreenWithoutGeo() {
        navController.viewControllers.removeLast()
        showMainScreen()
    }


    func showMainScreen() {
        let viewModel = MainScreenViewModel(coordinator: self)
        let controller = MainScreenController(viewModel: viewModel)
        self.navController.pushViewController(controller, animated: true)
    }

}
