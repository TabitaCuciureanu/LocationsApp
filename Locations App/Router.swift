//
//  Router.swift
//  Locations App
//
//  Created by Tabita Marusca on 29/10/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import UIKit

final class Router {
    private let window: UIWindow
    private let locationDataManager = LocationDataManager()
    private let locationManager = LocationManager()
    private let navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
    }

    func startFlow() {
        let viewModel = LocationListViewModel(locationDataManager: locationDataManager, locationManager: locationManager)
        navigationController.pushViewController(LocationListViewController(viewModel: viewModel, router: self), animated: true)
        self.window.rootViewController = navigationController
    }
    
    func goToDetailsScreen(location: RealmLocation) {
        let viewModel = LocationDetailsViewModel(label: location.label, address: location.address, coordinate: Coordinate(location.latitude, location.longitude), locationDataManager: locationDataManager)
        navigationController.pushViewController(LocationDetailsViewController(router: self, type: .detail, viewModel: viewModel), animated: true)
    }
    
    func goToAddNewLocationScreen() {
        let viewModel = LocationDetailsViewModel(label: nil, address: nil, coordinate: nil, locationDataManager: locationDataManager)
        navigationController.pushViewController(LocationDetailsViewController(router: self, type: .addNew, viewModel: viewModel), animated: true)
    }
}
