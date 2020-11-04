//
//  LocationManager.swift
//  Locations App
//
//  Created by Tabita Marusca on 03/11/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private var currentLocation: CLLocation?
    private var locationManager: CLLocationManager?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()

        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
        }
    }
    
    func kilometersBetweenCurrentLocationAnd(coordinate: Coordinate) -> Double {
        guard let latitude = CLLocationDegrees(exactly: coordinate.latitude), let longitude = CLLocationDegrees(exactly: coordinate.longitude), let currentLocation = currentLocation else { return -1 }
        
        return Double(CLLocation(latitude: latitude, longitude: longitude).distance(from: currentLocation))/1000
    }
}

