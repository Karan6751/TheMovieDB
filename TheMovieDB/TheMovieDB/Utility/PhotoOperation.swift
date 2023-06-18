//
//  PhotoOperation.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 18/06/23.
//

import Foundation
import UIKit

// MARK: - Photo Record State
enum PhotoRecordState {
    case new, downloaded, failed
}

// MARK: - Photo Record
final class PhotoRecord {
    // MARK: - Properties
    let url: URL
    var state: PhotoRecordState = .new
    var image = UIImage(named: "placeholder")
    lazy var imageURL: URL? = {
        guard let baseURLString = AppConfiguration.shared.imageBaseURL else {
            return nil
        }
        let urlString = url.absoluteString
        let imageDownloadURLString = baseURLString + urlString
        let imageDownloadURL = URL(string: imageDownloadURLString)
        return imageDownloadURL
    }()
    // MARK: - Constructor
    init(url: URL) {
        self.url = url
    }
}

// MARK: - Pending Operations
final class PendingOperations {
    // MARK: - Properties
    lazy var downloadInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Download Queue"
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
}

// MARK: - Image Downloader
final class ImageDownloade: Operation {
    // MARK: - Properties
    var photoRecord: PhotoRecord
    // MARK: - Constructor
    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    // MARK: - Operation Method
    override func main() {
        if isCancelled {
            return
        }
        guard let imageDownloadURL = photoRecord.imageURL, let imageData = try? Data(contentsOf: imageDownloadURL) else {
            photoRecord.state = .failed
            return
        }
        if isCancelled {
            return
        }
        
        if !imageData.isEmpty {
            photoRecord.state = .downloaded
            photoRecord.image = UIImage(data: imageData)
        } else {
            photoRecord.state = .failed
            photoRecord.image = UIImage(named: "placeholder")
        }
    }
}
