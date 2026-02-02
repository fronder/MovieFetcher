//
//  MovieSearchViewModel.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 30/01/26.
//

import Foundation
import Combine

final class MovieSearchViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var searchQuery = ""
    @Published var errorMessage: String?
    @Published var hasMorePages = true
    
    private var currentPage = 1
    private var totalPages = 1
    private var currentSearchQuery = ""
    
    private let searchMoviesUseCase: SearchMoviesUseCaseProtocol
    private let manageFavoritesUseCase: ManageFavoritesUseCaseProtocol
    
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    init(searchMoviesUseCase: SearchMoviesUseCaseProtocol, manageFavoritesUseCase: ManageFavoritesUseCaseProtocol) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.manageFavoritesUseCase = manageFavoritesUseCase
        
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if query.isEmpty {
                    self.movies = []
                    self.errorMessage = nil
                } else {
                    Task {
                        await self.searchMovies(query: query, resetResults: true)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func searchMovies(query: String, resetResults: Bool = false) async {
        searchTask?.cancel()
        
        if resetResults {
            currentPage = 1
            movies = []
            currentSearchQuery = query
        }
        
        guard !query.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        searchTask = Task {
            do {
                let result = try await searchMoviesUseCase.execute(query: query, page: currentPage)
                
                if !Task.isCancelled {
                    if resetResults {
                        movies = result.results
                    } else {
                        movies.append(contentsOf: result.results)
                    }
                    totalPages = result.totalPages
                    hasMorePages = currentPage < totalPages
                    isLoading = false
                }
            } catch {
                if !Task.isCancelled {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
        
        await searchTask?.value
    }
    
    func loadMoreMovies() async {
        guard !isLoading, hasMorePages, !currentSearchQuery.isEmpty else { return }
        
        currentPage += 1
        await searchMovies(query: currentSearchQuery, resetResults: false)
    }
    
    func isFavorite(movieId: Int) -> Bool {
        return manageFavoritesUseCase.isFavorite(movieId: movieId)
    }
    
    func toggleFavorite(movie: Movie) {
        do {
            try manageFavoritesUseCase.toggleFavorite(movie: movie)
            objectWillChange.send()
        } catch {
            errorMessage = "Failed to update favorites: \(error.localizedDescription)"
        }
    }
}
