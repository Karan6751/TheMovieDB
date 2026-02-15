//
//  HTTPTask.swift
//  MovieMaster
//
//  Created by Karandeep Singh Bhatia on 14/02/26.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPTask {
    case request
    case requestParameters(bodyEncoding: ParameterEncoding, urlParameters: Parameters?, bodyParameters: Parameters?)
    case requestParametersAndHeaders(bodyEncoding: ParameterEncoding, urlParameter: Parameters?, bodyParameters: Parameters?, additionalHeaders: HTTPHeaders?)
}
