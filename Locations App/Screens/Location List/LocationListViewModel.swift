//
//  LocationListViewModel.swift
//  Locations App
//
//  Created by Tabita Marusca on 03/11/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import UIKit
import RealmSwift

final class LocationListViewModel {
    // MARK: - Properties
    
    let placeholderImage = UIImage(named: "placeholder")
    var locations: Results<RealmLocation>? {
        didSet {
            locationsDidUpdate?()
        }
    }
    var locationsDidUpdate: (() -> Void)?
    private var locationDataManager: LocationDataManager
    private let locationManager: LocationManager
    
    // MARK: - Init

    init(locationDataManager: LocationDataManager, locationManager: LocationManager) {
        self.locationDataManager = locationDataManager
        self.locationManager = locationManager
    }
    
    // MARK: - Internal Methods
    
    func cellTextFor(index: Int) -> String? {
        guard let locations = locations else { return nil }
        var text = ""
        if !locations[index].address.isEmpty {
            text += locations[index].address
        }
        if let distance = distanceTo(coordinate: Coordinate(latitude: locations[index].latitude, longitude: locations[index].longitude)) {
            text += !text.isEmpty ? " - " + distance : distance
        }
        return text
    }
    
    func getLocations() {
        locationDataManager.getLocations { [weak self] newLocations in
            self?.locations = newLocations
        }
    }
    
    // MARK: - Private Methods
    
    private func distanceTo(coordinate: Coordinate) -> String? {
        let distance = locationManager.kilometersBetweenCurrentLocationAnd(coordinate: coordinate)
        if distance == -1 {
            return nil
        }
        return String(format: "%.1f km away", distance)
    }
}
