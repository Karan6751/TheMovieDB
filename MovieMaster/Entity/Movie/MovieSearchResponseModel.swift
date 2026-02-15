//
//  MovieSearchResponseModel.swift
//  MovieMaster
//
//  Created by Karandeep Singh Bhatia on 15/02/26.
//


struct MovieSearchResponseModel: Decodable {
    let page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Decodable {
    let description: String?
    let favoriteCount, id, itemCount: Int?
    let listType: ListType?
    let name: String?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case description
        case favoriteCount = "favorite_count"
        case id
        case itemCount = "item_count"
        case listType = "list_type"
        case name
        case posterPath = "poster_path"
    }
}


enum ListType: String, Decodable {
    case movie = "movie"
}
