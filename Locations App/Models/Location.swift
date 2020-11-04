//
//  Location.swift
//  Locations App
//
//  Created by Tabita Marusca on 03/11/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import Foundation
import RealmSwift

struct Location: Codable {
    let latitude: Double?
    let longitude: Double?
    let lat: Double?
    let lng: Double?
    let label: String
    let address: String
    let image: String?
}

struct LocationsData: Codable {
    let status: String
    let locations: [Location]
}

final class RealmLocation: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var label = ""
    @objc dynamic var address = ""
    @objc dynamic var image = ""
}
