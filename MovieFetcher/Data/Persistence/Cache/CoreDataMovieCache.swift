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
    
    func getCachedMovies(query: String, page: Int) -> [Movie] {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "searchQuery == %@ AND page == %d",
            query.lowercased(),
            page
        )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.map { $0.toMovie() }
        } catch {
            print("Failed to fetch cached movies: \(error)")
            return []
        }
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

    func addToFavorites(movie: Movie) throws {
        let context = coreDataManager.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)
        
        let existingEntities = try context.fetch(fetchRequest)
        
        if existingEntities.isEmpty {
            let entity = FavoriteMovieEntity(context: context)
            entity.update(from: movie)
            entity.addedDate = Date()
            try coreDataManager.saveContext()
        }
    }
    
    func isFavorite(movieId: Int) -> Bool {
        let context = coreDataManager.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
    
    func getFavoriteMovies() -> [Movie] {
        let context = coreDataManager.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "addedDate", ascending: false)]
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.map { $0.toMovie() }
        } catch {
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }
}
