//
//  MovieListViewModel.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation
import Combine

final class MovieListViewModel {
    
    // MARK: - Properties
    private let networkManger: MovieNetworkManager
    private (set) var movieList: MovieSearchResponseModel
    private (set) var cellModels: [MovieListCellModel] = []
    private (set) var photos: [PhotoRecord] = []
    let pendingOperations = PendingOperations()
    
    private (set) var updateUI: PassthroughSubject = PassthroughSubject<[MovieListCellModel], Never>()
    private (set) var updateUIOnImageDownload: PassthroughSubject = PassthroughSubject<IndexPath, Never>()
    var expandedRows: IndexSet = []
    
    // MARK: - Constructore
    init(networkManger: MovieNetworkManager, movieList: MovieSearchResponseModel) {
        self.networkManger = networkManger
        self.movieList = movieList
        populateCellModels(from: movieList)
    }
    
    private func populateCellModels(from searchResult: MovieSearchResponseModel) {
        guard let results = searchResult.results, !results.isEmpty else { return }
        
        for result in results {
            let cellModel = MovieListCellModel()
            cellModel.movieTitle = result.title
            cellModel.averageRating = result.rating
            cellModel.overview = result.overview
            cellModel.posterPath = result.backdropPath
            cellModel.releaseDate = result.releaseDate
            if let posterPath = result.backdropPath, let posterURL = URL(string: posterPath) {
                let photoRecord = PhotoRecord(url: posterURL)
                photos.append(photoRecord)
            }
            cellModels.append(cellModel)
        }
        
        updateUI.send(cellModels)
    }
    
    func getCellModel(at indexPath: IndexPath) -> MovieListCellModel {
        return cellModels[indexPath.row]
    }
    func getPhotoRecord(at indexPath: IndexPath) -> PhotoRecord {
        return photos[indexPath.row]
    }
    
}
// MARK: - Image Download
extension MovieListViewModel {
    func startOperation(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        switch photoRecord.state {
        case .new:
            startDownload(for: photoRecord, at: indexPath)
        case .downloaded, .failed:
            updateUIOnImageDownload.send(indexPath)
        }
    }
    
    private func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        guard pendingOperations.downloadInProgress[indexPath] == nil else {
            return
        }
        let downloader = ImageDownloade(photoRecord: photoRecord)
        
        downloader.completionBlock = { [weak self] in
            if downloader.isCancelled {
                return
            }
            self?.pendingOperations.downloadInProgress.removeValue(forKey: indexPath)
            self?.updateUIOnImageDownload.send(indexPath)
        }
        pendingOperations.downloadInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func suspendAllOperations() {
        pendingOperations.downloadQueue.isSuspended = true
    }
    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
    }
    func loadImageForVisibleRows(visibleRows indexPaths: [IndexPath]) {
        let allPendingOperations = Set(pendingOperations.downloadInProgress.keys)
        
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(indexPaths)
        toBeCancelled.subtract(visiblePaths)
        
        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
        
        for indexPath in toBeCancelled where indexPath.row < photos.count {
            if let pendingDownload = pendingOperations.downloadInProgress[indexPath] {
                pendingDownload.cancel()
            }
            pendingOperations.downloadInProgress.removeValue(forKey: indexPath)
        }
        
        for indexPath in toBeStarted where indexPath.row < photos.count {
            let recordToProcess = photos[indexPath.row]
            startDownload(for: recordToProcess, at: indexPath)
        }
    }
}
