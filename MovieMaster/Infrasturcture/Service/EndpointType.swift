//
//  EndpointType.swift
//  MovieMaster
//
//  Created by Karandeep Singh Bhatia on 14/02/26.
//

import Foundation

protocol EndpointType {
    var baseURL: URL { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var task: HTTPTask { get }
    var method: HTTPMethod { get }
}
