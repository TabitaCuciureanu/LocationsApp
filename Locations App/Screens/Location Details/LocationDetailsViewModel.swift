//
//  LocationDetailsViewModel.swift
//  Locations App
//
//  Created by Tabita Marusca on 01/11/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import Foundation

typealias Coordinate = (latitude: Double, longitude: Double)

final class LocationDetailsViewModel {
    // MARK: - Properties
    
    var label: String?
    var labelTitle = "label"
    
    var address: String?
    var addressTitle = "address"
    
    var coordinate: Coordinate?
    
    var latitudeTitle = "latitude"
    var latitudeString: String? {
        guard let latitude = coordinate?.latitude else {
            return nil
        }
        return latitude.description
    }
    
    var longitudeTitle = "longitude"
    var longitudeString: String? {
           guard let longitude = coordinate?.longitude else {
               return nil
           }
           return longitude.description
       }
    
    var saveTitle = "Save"
    
    private let locationDataManager: LocationDataManager
    
    // MARK: - Init
    
    init(label: String?, address: String?, coordinate: Coordinate?, locationDataManager: LocationDataManager) {
        self.label = label
        self.address = address
        self.coordinate = coordinate
        
        self.locationDataManager = locationDataManager
    }
    
    // MARK: - Internal Methods
    
    func saveNewLocation(label: String, address: String, coordinate: Coordinate) {
        locationDataManager.addNew(location: LocationViewModel(coordinate: coordinate, label: label, address: address, image: nil))
    }
}
