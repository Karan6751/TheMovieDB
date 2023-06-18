//
//  HTTPTask.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPTask {
    case request
    case requestParameters(bodyEncoding: ParameterEncoding, urlParameters: Parameters?, bodyParameters: Parameters?)
    case requestParametersAndHeaders(bodyEncoding: ParameterEncoding, urlParameters: Parameters?, bodyParameters: Parameters?, additionalHeaders: HTTPHeaders?)
}
