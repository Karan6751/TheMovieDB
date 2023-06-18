//
//  AppFactoryDIContainer.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation
import UIKit

protocol MovieNetworkManagerProtocol {
    func makeMovieNetworkManager() -> MovieNetworkManager
}
protocol SearchMovieDIProtocol: MovieNetworkManagerProtocol {
    func makeSearchMovieViewController() -> SearchMovieViewController
    func makeSearchMovieViewModel() -> SearchMovieViewModel
}
protocol MovieListDIProtocol: MovieNetworkManagerProtocol {
    func makeMovieListViewController(movieList: MovieSearchResponseModel) -> MovieListViewController
    func makeMovieListViewModel(movieList: MovieSearchResponseModel) -> MovieListViewModel
}
final class AppFactoryDIContainer {
    static let shared = AppFactoryDIContainer()
    private init() { }
}

// MARK: - Movie Network Manger DI Container
extension AppFactoryDIContainer: MovieNetworkManagerProtocol {
    func makeMovieNetworkManager() -> MovieNetworkManager {
        MovieNetworkManager()
    }
}

// MARK: - Search Movie DI Container
extension AppFactoryDIContainer: SearchMovieDIProtocol {
    func makeSearchMovieViewController() -> SearchMovieViewController {
        let viewModel = makeSearchMovieViewModel()
        let designatedController = UIStoryboard(name: "\(SearchMovieViewController.self)", bundle: .main)
            .instantiateViewController(identifier: "\(SearchMovieViewController.self)") { coder in
                return SearchMovieViewController(viewModel: viewModel, code: coder)
            }
        return designatedController
    }
    
    func makeSearchMovieViewModel() -> SearchMovieViewModel {
        SearchMovieViewModel(networkManager: makeMovieNetworkManager())
    }
}

// MARK: - Movie List DI Container
extension AppFactoryDIContainer: MovieListDIProtocol {
    func makeMovieListViewController(movieList: MovieSearchResponseModel) -> MovieListViewController {
        let viewModel = makeMovieListViewModel(movieList: movieList)
        let designatedController = UIStoryboard(name: "\(MovieListViewController.self)", bundle: .main)
            .instantiateViewController(identifier: "\(MovieListViewController.self)") { coder in
                return MovieListViewController(viewModel: viewModel, coder: coder)
            }
        return designatedController
    }
    
    func makeMovieListViewModel(movieList: MovieSearchResponseModel) -> MovieListViewModel {
        MovieListViewModel(networkManger: makeMovieNetworkManager(), movieList: movieList)
    }
}
