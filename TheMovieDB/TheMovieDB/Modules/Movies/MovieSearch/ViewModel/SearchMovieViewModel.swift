//
//  SearchMovieViewModel.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation
import Combine

final class SearchMovieViewModel {
    // MARK: - Properties
    private (set) var updateUI: PassthroughSubject = PassthroughSubject<MovieSearchResponseModel?, Never>()
    
    private let networkManager: MovieNetworkManager
    
    // MARK: - Constructore
    init(networkManager: MovieNetworkManager) {
        self.networkManager = networkManager
    }
    // MARK: - Search Movie
    func search(movie: String) {
        networkManager.executeMovieSearchRequest(query: movie) { [weak self] result in
            switch result {
            case .success(let response):
                if response.results?.isEmpty == false {
                    self?.updateUI.send(response)
                } else {
                    self?.updateUI.send(nil)
                }
            case .failure(let error):
                print("Error Fetching Movie List: \(error.localizedDescription)")
                self?.updateUI.send(nil)
            }
        }
    }
}
