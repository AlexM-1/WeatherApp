//
//  OneLocationViewModel.swift
//  WeatherApp
//
//  Created by Alex M on 12.01.2023.
//

import Foundation

final class OneLocationViewModel {

    enum Action {
        case settingsButtonTap
        case locationButtonTap
        case pulledRefresh
        case cellForecastDidSelect(Int)
        case detailButtonTap
    }

    enum State {
        case initial
        case loading
        case loaded
        case error
    }

    var location: Location!

    private let coordinator: AppCoordinator

    var stateChanged: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            stateChanged?(state)
        }
    }


    init(coordinator: AppCoordinator, location: Location) {
        self.coordinator = coordinator
        self.location = location
        self.state = .loading
        Model.reloadLocation(location: location) {
            self.state = .loaded
        }
    }


    func changeState(_ action: Action) {
        switch action {

        case .settingsButtonTap:
            self.coordinator.showSettingsScreen()


        case .locationButtonTap:
            self.coordinator.showCityManagementVC()


        case .pulledRefresh:
            self.state = .loading
            Model.reloadLocation(location: location) {
                self.state = .loaded
            }


        case .cellForecastDidSelect(let index):
            self.coordinator.showDailySummaryVC(with: location, at: index)
            print (index)

        case .detailButtonTap:
            self.coordinator.showDailySummaryVC(with: location, at: 0)

        }
    }
}

