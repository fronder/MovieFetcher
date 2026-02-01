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
    
    func cacheMovies(_ movies: [Movie], query: String, page: Int) {
        let context = coreDataManager.viewContext
        
        context.perform {
            for movie in movies {
                let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(
                    format: "id == %d AND searchQuery == %@ AND page == %d",
                    movie.id,
                    query.lowercased()
                )
                
                do {
                    let existingEntities = try context.fetch(fetchRequest)
                    let entity = existingEntities.first ?? MovieEntity(context: context)
                    
                    entity.update(from: movie)
                    entity.searchQuery = query.lowercased()
                    entity.page = Int64(page)
                    entity.cachedDate = Date()
                    
                    try self.coreDataManager.saveContext()
                } catch {
                    print("Failed to cache movie: \(error)")
                }
            }
        }
    }

}
