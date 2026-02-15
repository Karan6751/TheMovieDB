//
//  Router.swift
//  MovieMaster
//
//  Created by Karandeep Singh Bhatia on 15/02/26.
//

import Foundation

final class Router<EndPoint: EndpointType>: NetworkRouter {
    
    func request<T>(_ route: EndPoint) async throws -> T where T: Decodable {
        let request = try buildRequest(from: route)
        let session = URLSession.shared
        let (data, response) = try await session.data(for: request)
        
        // Validate HTTP response status code if applicable
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        request.httpMethod = route.method.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue(GeneralConstants.commonContentTypeHeaderValue, forHTTPHeaderField: GeneralConstants.commonContentTypeHeaderKey)
            case .requestParameters(let bodyEncoding, let urlParameters, let bodyParameters):
                try configure(bodyEncoding: bodyEncoding, urlParameters: urlParameters, bodyParameters: bodyParameters, request: &request)
            case .requestParametersAndHeaders(let bodyEncoding, let urlParameter, let bodyParameters, let additionalHeaders):
                addAdditionalHeaders(request: &request, headers: additionalHeaders)
                try configure(bodyEncoding: bodyEncoding, urlParameters: urlParameter, bodyParameters: bodyParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    private func configure(bodyEncoding: ParameterEncoding, urlParameters: Parameters?, bodyParameters: Parameters?, request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(request: &request, urlParameters: urlParameters, bodyParameters: bodyParameters)
        } catch {
            throw error
        }
    }
    
    private func addAdditionalHeaders(request: inout URLRequest, headers: HTTPHeaders?) {
        guard let headers else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}

