//
//  MovieNetworkManager.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation

final class MovieNetworkManager {
    private let route = Router<MovieAPIEndPoint>()
    
    func executeMovieSearchRequest(query: String, completion: @escaping (Result<MovieSearchResponseModel, NetworkError>)-> Void) {
        route.request(.search(query: query)) { data, response, error in
            if error != nil {
                completion(.failure(.noInternet))
            }
            do {
                guard let data else { return }
                let apiResponse = try JSONDecoder().decode(MovieSearchResponseModel.self, from: data)
                completion(.success(apiResponse))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
    }
}
