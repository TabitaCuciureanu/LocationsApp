//
//  LocationDataManager.swift
//  Locations App
//
//  Created by Tabita Marusca on 03/11/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import Foundation
import RealmSwift

struct LocationViewModel {
    var coordinate: Coordinate?
    var label: String?
    var address: String?
    var image: String?
}

final class LocationDataManager {
    // MARK: - Properties
    
    private var locations: Results<RealmLocation> = {
        let realm = try! Realm()
        return realm.objects(RealmLocation.self)
    }()
    
    // MARK: - Init
    
    func getLocations(completion: @escaping (Results<RealmLocation>) -> Void) {
        guard locations.count == 0 else {
            completion(self.locations)
            return
        }
        
        getLocationsFromAPI { [weak self] locations, _ in
            guard let self = self, let locations = locations else { return }
            
            locations.forEach {
                let latitude = $0.latitude ?? $0.lat ?? 0.0
                let longitude = $0.longitude ?? $0.lng ?? 0.0
                
                self.addNew(location: LocationViewModel(coordinate: Coordinate(latitude: latitude,
                                                                          longitude: longitude),
                                                   label: $0.label,
                                                   address: $0.address,
                                                   image: $0.image
                ))
            }
            
            completion(self.locations)
        }
    }
    
    // MARK: - Internal Methods
    
    func addNew(location: LocationViewModel) {
        let realm = try! Realm() 
        
        try! realm.write {
            let newLocation = RealmLocation()
            newLocation.latitude = location.coordinate?.latitude ?? 0.0
            newLocation.longitude = location.coordinate?.longitude ?? 0.0
            newLocation.label = location.label ?? ""
            newLocation.address = location.address ?? ""
            newLocation.image = location.image ?? ""
            realm.add(newLocation)
        }
    }
        
    // MARK: - Private Methods
        
    private func getLocationsFromAPI(completion: @escaping (([Location]?, Error?) -> Void)) {
        let urlString = "http://demo1042273.mockable.io/mylocations"
        
        self.loadJson(fromURLString: urlString) { (result) in
            switch result {
            case .success(let data):
                completion(self.parse(jsonData: data), nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
    
    private func parse(jsonData: Data) -> [Location]? {
        do {
            return try JSONDecoder().decode(LocationsData.self,
                                            from: jsonData).locations
        } catch {
            return nil
        }
    }
    
}
