//
//  PersistenceManager.swift
//  GourmetGuide
//
//  Created by Min Kim on 12/11/23.
//

import Foundation

///Persistence manager action types
enum PersistenceActionType {
    case add, remove
}

///Persistence manager for our UserDefaults
enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    ///Updates our favorites array with a recipe and an action
    static func updateWith(favorite: GGRecipe, actionType: PersistenceActionType, completed: @escaping(Error?) -> Void){
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                var retrievedFavorites = favorites
                switch actionType {
                case .add:
                    guard !retrievedFavorites.contains(favorite) else {
                        print("Already in favorites")
                        return
                    }
                    retrievedFavorites.append(favorite)
                    print("\(favorite.title) added to favorites")
                case .remove:
                    retrievedFavorites.removeAll { $0.id == favorite.id }
                    
                }
                completed(save(favorites: retrievedFavorites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    ///Retrieves favorites from UserDefaults
    static func retrieveFavorites(completed: @escaping (Result<[GGRecipe], Error>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([GGRecipe].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(error))
        }
    }
    
    ///Saves a recipe to our favorites
    static func save(favorites: [GGRecipe]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return error
        }
    }
    
}
