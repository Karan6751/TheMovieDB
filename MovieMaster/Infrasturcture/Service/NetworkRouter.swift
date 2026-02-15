//
//  NetworkRouter.swift
//  MovieMaster
//
//  Created by Karandeep Singh Bhatia on 15/02/26.
//

import Foundation

protocol NetworkRouter {
    associatedtype EndPoint: EndpointType
    
    func request<T: Decodable>(_ route: EndPoint) async throws -> T
}
