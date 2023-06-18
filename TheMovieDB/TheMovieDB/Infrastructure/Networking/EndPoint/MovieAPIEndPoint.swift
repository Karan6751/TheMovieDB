//
//  MovieAPIEndPoint.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation

enum MovieAPIEndPoint {
    case search(query: String)
}

extension MovieAPIEndPoint: EndPointType {
    var baseURL: URL {
        guard let baseURLString = AppConfiguration.shared.baseURL, let baseURL = URL(string: baseURLString) else {
            preconditionFailure("BASE URL Cannot be nil")
        }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .search:
            return "search/movie"
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var task: HTTPTask {
        switch self {
        case .search(let query):
            return .requestParameters(bodyEncoding: .urlEncoding, urlParameters: ["query": query, "api_key": AppConfiguration.shared.apiKey ?? ""], bodyParameters: nil)
        }
    }
    
    var method: HttpMethod {
        return .get
    }
    
    
}
