//
//  MockData.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 01/02/26.
//

import Foundation
@testable import MovieFetcher

struct MockData {
    static let movie = Movie(
        id: 1,
        title: "Test Movie",
        overview: "Test overview",
        posterPath: "/test.jpg",
        backdropPath: "/backdrop.jpg",
        releaseDate: "2024-01-01",
        voteAverage: 8.5,
        voteCount: 1000,
        popularity: 100.0
    )
    
    static let movies = [
        movie,
        Movie(
            id: 2,
            title: "Test Movie 2",
            overview: "Test overview 2",
            posterPath: "/test2.jpg",
            backdropPath: "/backdrop2.jpg",
            releaseDate: "2024-02-01",
            voteAverage: 7.5,
            voteCount: 500,
            popularity: 80.0
        )
    ]
    
    static let searchResult = MovieSearchResult(
        page: 1,
        results: movies,
        totalPages: 1,
        totalResults: 2
    )
}

