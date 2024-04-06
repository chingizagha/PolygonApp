//
//  DatabaseManager.swift
//  PolygonMap
//
//  Created by Chingiz on 30.03.24.
//

import UIKit
import MapKit
import CoreData

enum DatabaseError: String, Error{
    case failedToSaveData
    case failedToLoadData
    case failedToDeleteData
}

enum PersistenceActionType {
    case add, remove
}

class DatabaseManager {
    
    static private let defaults = UserDefaults.standard
        
        enum Keys {
            static let polygons = "polygons3"
        }
        
        static func updateWith(model: Polygon, actionType: PersistenceActionType, completion: @escaping (Error?) -> Void) {
            retrievePolygons { result in
                switch result {
                case .success(var polygons):
                    switch actionType {
                    case .add:
                        guard !polygons.contains(model) else {
                            completion(DatabaseError.failedToLoadData)
                            return
                        }
                        polygons.append(model)
                    case .remove:
                        polygons.removeAll {  $0.title == model.title }
                    }
                    completion(save(polygons: polygons))
                case .failure(let error):
                    completion(error)
                }
            }
        }
        
        
    static func retrievePolygons(completion: @escaping (Result<[Polygon], Error>) -> Void) {
            guard let polygonsData = defaults.object(forKey: Keys.polygons) as? Data else {
                completion(.success([]))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let polygons = try decoder.decode([Polygon].self, from: polygonsData)
                completion(.success(polygons))
            } catch {
                completion(.failure(DatabaseError.failedToLoadData))
            }
        }
    
    static func retrieveOnePolygon(title: String, completion: @escaping (Result<Polygon, Error>) -> Void) {
            guard let polygonsData = defaults.object(forKey: Keys.polygons) as? Data else {
                completion(.failure(DatabaseError.failedToLoadData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let polygons = try decoder.decode([Polygon].self, from: polygonsData)
                let polygon = polygons.first { $0.title == title }
                completion(.success(polygon!))
            } catch {
                completion(.failure(DatabaseError.failedToLoadData))
            }
        }

        
        
        static func save(polygons: [Polygon]) -> Error? {
            do {
                let encoder = JSONEncoder()
                let encodedFavorites = try encoder.encode(polygons)
                defaults.setValue(encodedFavorites, forKey: Keys.polygons)
                return nil
            } catch {
                return DatabaseError.failedToSaveData
            }
        }
}
