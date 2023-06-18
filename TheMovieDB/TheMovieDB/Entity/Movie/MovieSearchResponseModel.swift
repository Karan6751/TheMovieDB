//
//  MovieSearchResponseModel.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import Foundation

struct MovieSearchResponseModel {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Results]?
    
}
extension MovieSearchResponseModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decodeIfPresent(Int.self, forKey: .page)
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
        totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults)
        results = try container.decodeIfPresent([Results].self, forKey: .results)
    }
}

struct Results {
    let id: Int?
    let title: String?
    let backdropPath: String?
    let overview: String?
    let rating: Double?
    let releaseDate: String?
}

extension Results: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case backdropPath = "backdrop_path"
        case overview
        case rating = "vote_average"
        case releaseDate = "release_date"
    }
    init(from decoder: Decoder) throws {
        let continer = try decoder.container(keyedBy: CodingKeys.self)
        id = try continer.decode(Int.self, forKey: .id)
        title = try continer.decode(String.self, forKey: .title)
        backdropPath = try continer.decodeIfPresent(String.self, forKey: .backdropPath)
        overview = try continer.decode(String.self, forKey: .overview)
        rating = try continer.decode(Double.self, forKey: .rating)
        releaseDate = try continer.decode(String.self, forKey: .releaseDate)
    }
}
