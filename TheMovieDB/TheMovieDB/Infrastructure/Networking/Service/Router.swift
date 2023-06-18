//
//  Router.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation

final class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkCompletion) {
        do {
            let request = try buildRequest(from: route)
            let session = URLSession.shared
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
            task?.resume()
        } catch {
            completion(nil, nil, error)
        }
    }
    
    func cancel() {
        task?.cancel()
    }
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        request.httpMethod = route.method.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue(GeneralConstants.commonContentTypeHeaderKey, forHTTPHeaderField: GeneralConstants.commonContentTypeHeaderValue)
            case .requestParameters(let bodyEncoding, let urlParameters, let bodyParameters):
                try configure(bodyEncoding: bodyEncoding, urlParameters: urlParameters, bodyParameters: bodyParameters, request: &request)
            case .requestParametersAndHeaders(let bodyEncoding, let urlParameters, let bodyParameters, let additionalHeaders):
                addAdditionalHeaders(request: &request, headers: additionalHeaders)
                try configure(bodyEncoding: bodyEncoding, urlParameters: urlParameters, bodyParameters: bodyParameters, request: &request)
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
