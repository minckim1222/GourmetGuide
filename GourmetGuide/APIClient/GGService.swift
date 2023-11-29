//
//  GGService.swift
//  GourmetGuide
//
//  Created by Min Kim on 11/13/23.
//

import Foundation

/// Our API Service
class GGService {
    
    static let shared = GGService()
    private init() {}
    
    enum GGServiceError: String, Error {
        case invalidUrl = "The url was invalid"
        case failedToCreateRequest = "Failed to create request"
        case invalidResponse = "Invalid response receieved"
        case failedToGetData = "Failed to get data"
        case failedToDecodeData = "Failed to decode the data"
    }
    
    private struct Constants {
        static let baseUrl = "https://api.spoonacular.com/"
        static let apiKey = "26fdbd8324b24a05bb913fa44613674a"
    }
    
    
    /// Function to get random recipes for our collection view
    /// - Parameters:
    ///   - endpoint: Random endpoint
    ///   - completed: Returns a random list of recipes
    public func getRandomRecipes(from endpoint: GGEndpoint, completed: @escaping(Result<[GGRecipe], GGServiceError>) -> Void){
        
        let endpointUrl = Constants.baseUrl + endpoint.rawValue + "apiKey=\(Constants.apiKey)&number=1"
        guard let url = URL(string: endpointUrl) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.failedToCreateRequest))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.failedToGetData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(GGRandomRecipeResults.self, from: data)
                let randomRecipes = json.recipes
                completed(.success(randomRecipes))
            } catch {
                completed(.failure(.failedToDecodeData))
            }
        }
        task.resume()
    }
    
    /// Get recipes based on diet type
    /// - Parameters:
    ///   - endpoint: Endpoint for diet type
    ///   - parameters: Any additional parameters
    ///   - completed: Completion Handler
    public func getDietaryRecipes(from endpoint: GGEndpoint, withParameters parameters: [URLQueryItem] = [], completed: @escaping(Result<[GGRecipeResponse], GGServiceError>) -> Void){
        
        let endpointUrl = Constants.baseUrl + endpoint.rawValue
        var components = URLComponents(string: endpointUrl)
        var builtParameters = parameters
        builtParameters.append(URLQueryItem(name: "apiKey", value: Constants.apiKey))
        components?.queryItems = builtParameters
        
        guard let url = components?.url else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.failedToCreateRequest))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.failedToGetData))
                return
            }
            print(data)
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(GGResponseModel.self, from: data)
                let recipes = json.results
                completed(.success(recipes))
            } catch {
                completed(.failure(.failedToDecodeData))
            }
        }
        task.resume()
    }
    
    
    /// Get information for a single recipe
    /// - Parameters:
    ///   - endpoint: Single recipe endpoind
    ///   - id: Id of the recipe to search
    ///   - completed: Completion handler that returns the single recipe
    public func getSingleRecipe(from endpoint: GGEndpoint, with id: Int, completed: @escaping(Result<GGRecipe, GGServiceError>) -> Void){
        
        let endpointUrl = Constants.baseUrl + endpoint.rawValue + "\(id)/information?apiKey=\(Constants.apiKey)"
        print(endpointUrl)
        guard let url = URL(string: endpointUrl) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.failedToCreateRequest))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.failedToGetData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let recipe = try decoder.decode(GGRecipe.self, from: data)
                completed(.success(recipe))
            } catch {
                completed(.failure(.failedToDecodeData))
            }
        }
        task.resume()
    }
}
