//
//  EndPointType.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var task: HTTPTask { get }
    var method: HttpMethod  { get }
}
