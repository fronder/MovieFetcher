//
//  FavoriteMovieEntity+CoreDataProperties.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 02/02/26.
//
//

public import Foundation
public import CoreData


public typealias FavoriteMovieEntityCoreDataPropertiesSet = NSSet

extension FavoriteMovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovieEntity> {
        return NSFetchRequest<FavoriteMovieEntity>(entityName: "FavoriteMovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var overview: String
    @NSManaged public var posterPath: String?
    @NSManaged public var backdropPath: String?
    @NSManaged public var releaseDate: String
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int64
    @NSManaged public var popularity: Double
    @NSManaged public var addedDate: Date?

    func toMovie() -> Movie {
        return Movie(
            id: Int(id),
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            voteCount: Int(voteCount),
            popularity: popularity
        )
    }
    
    func update(from movie: Movie) {
        self.id = Int64(movie.id)
        self.title = movie.title
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.backdropPath = movie.backdropPath
        self.releaseDate = movie.releaseDate
        self.voteAverage = movie.voteAverage
        self.voteCount = Int64(movie.voteCount)
        self.popularity = movie.popularity
    }
}

extension FavoriteMovieEntity : Identifiable {

}
