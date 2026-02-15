//
//  ParameterEncoder.swift
//  MovieMaster
//
//  Created by Karandeep Singh Bhatia on 14/02/26.
//

import Foundation

typealias Parameters = [String: Any]

enum NetworkError: Error {
    case missingURL
    case encodingFailed
    case decodingFailed
    case noInternet
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
