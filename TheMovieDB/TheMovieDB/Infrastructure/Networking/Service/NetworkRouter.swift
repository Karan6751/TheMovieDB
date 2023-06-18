//
//  NetworkRouter.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation

typealias NetworkCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkRouter {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkCompletion)
    func cancel()
}
