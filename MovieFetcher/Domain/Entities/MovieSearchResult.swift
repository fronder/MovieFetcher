//
//  MovieSearchResult.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

struct MovieSearchResult: Equatable, Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}
