//
//  MovieNetworkManager.swift
//  MovieMaster
//
//  Created by Karandeep Singh Bhatia on 15/02/26.
//

import Foundation

final class MovieNetworkManager {
    private let route = Router<MovieAPIEndPoint>()
    
    func executeMovieSearchRequest(query: String) async -> MovieSearchResponseModel? {
        do {
            let response: MovieSearchResponseModel = try await route.request(.search(query: query))
            return response
        } catch {
            print("Error \(error.localizedDescription)")
            return nil
        }
    }
}
