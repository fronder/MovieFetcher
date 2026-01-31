//
//  CoreDataMovieCache.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 01/02/26.
//

import Foundation
import CoreData

final class CoreDataMovieCache: MovieCacheProtocol {
    private let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    func cacheMovies(_ movies: [Movie], query: String) {
        
    }

}
