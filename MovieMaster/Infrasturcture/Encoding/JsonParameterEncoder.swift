//
//  JSONParameterEncoder.swift
//  MovieMaster
//
//  Created by Karandeep Singh Bhatia on 14/02/26.
//

import Foundation

struct JSONParameterEncoder: ParameterEncoder {
    static func encode(request: inout URLRequest, parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonAsData
            request.setValue(GeneralConstants.commonContentTypeHeaderValue, forHTTPHeaderField: GeneralConstants.commonContentTypeHeaderKey)
        } catch {
            throw error
        }
    }
}
