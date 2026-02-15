//
//  MovieAPIEndPoint.swift
//  MovieMaster
//
//  Created by Karandeep Singh Bhatia on 15/02/26.
//

import Foundation

enum MovieAPIEndPoint {
    case search(query: String)
}

extension MovieAPIEndPoint: EndpointType {
    var baseURL: URL {
        guard let baseURLString = AppConfiguration.shared.baseURL, let baseURL = URL(string: baseURLString) else {
            preconditionFailure("BASE URL Cannot be nil")
        }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .search(let query):
            return "search/movie"
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var task: HTTPTask {
        switch self {
        case .search(let query):
                .requestParameters(bodyEncoding: .urlEncoding, urlParameters: ["query": query, "api_key": AppConfiguration.shared.apiKey ?? ""], bodyParameters: nil)
        }
    }
}
