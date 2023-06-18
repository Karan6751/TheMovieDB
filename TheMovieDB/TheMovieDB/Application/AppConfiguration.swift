//
//  AppConfiguration.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation

final class AppConfiguration {
    static let shared = AppConfiguration()
    private init() { }
    
    lazy var baseURL: String? = {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
            return nil
        }
        return baseURL
    }()
    
    lazy var apiKey: String? = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            return nil
        }
        return apiKey
    }()
    
    lazy var imageBaseURL: String? = {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "IMAGE_BASE_URL") as? String else {
            return nil
        }
        return baseURL
    }()
}
