//
//  MovieRepositoryProtocol.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 03/02/26.
//

import Foundation

typealias MovieRepositoryProtocol = MovieDataRepositoryProtocol & MovieCacheRepositoryProtocol & FavoritesRepositoryProtocol
