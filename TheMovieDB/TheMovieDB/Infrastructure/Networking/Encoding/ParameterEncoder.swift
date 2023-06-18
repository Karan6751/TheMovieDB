//
//  ParameterEncoder.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation

typealias Parameters = [String: Any]

enum NetworkError: String, Error {
    case missingURL = "URL is missing"
    case encodingFailed = "Failed to encode"
    case decodingFailed = "Failed to decode"
    case noInternet = "No Internet"
}

protocol ParameterEncoder {
    static func encode(request: inout URLRequest, parameters: Parameters) throws
}

enum ParameterEncoding {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    
    func encode(request: inout URLRequest, urlParameters: Parameters?, bodyParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters else { return }
                try URLParameterEncoder.encode(request: &request, parameters: urlParameters)
            case .jsonEncoding:
                guard let bodyParameters else { return }
                try JSONParameterEncoder.encode(request: &request, parameters: bodyParameters)
            case .urlAndJsonEncoding:
                guard let urlParameters, let bodyParameters else { return }
                try URLParameterEncoder.encode(request: &request, parameters: urlParameters)
                try JSONParameterEncoder.encode(request: &request, parameters: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}
