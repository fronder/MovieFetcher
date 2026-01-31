//
//  MovieCacheProtocol.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import Foundation

protocol MovieCacheProtocol {
    func cacheMovies(_ movies: [Movie], query: String)
}
