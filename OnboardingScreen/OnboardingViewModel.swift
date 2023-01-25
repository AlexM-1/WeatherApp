//
//  OnboardingViewModel.swift
//  WeatherApp
//
//  Created by Alex M on 29.12.2022.
//

final class OnboardingViewModel {
    
    private let coordinator: AppCoordinator


    enum Action {
        case useGeo
        case dismissUseGeo
    }
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    func changeState(_ action: Action) {
        switch action {
        case .useGeo:
            self.coordinator.showScreenWithGeo()

        case .dismissUseGeo:
            self.coordinator.showScreenWithoutGeo()
        }
        
    }
}

