//
//  URLParameterEncoder.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation

struct URLParameterEncoder: ParameterEncoder {
    static func encode(request: inout URLRequest, parameters: Parameters) throws {
        guard let url = request.url else {
            throw NetworkError.missingURL
        }
        if var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponent.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponent.queryItems?.append(queryItem)
            }
            request.url = urlComponent.url
        }
    }
}
