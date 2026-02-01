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
    
    private let searchMoviesUseCase: SearchMoviesUseCaseProtocol
    
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    init(searchMoviesUseCase: SearchMoviesUseCaseProtocol) {
        self.searchMoviesUseCase = searchMoviesUseCase
        
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
                        await self.searchMovies(query: query)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func searchMovies(query: String) async {
        searchTask?.cancel()
        
        guard !query.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        searchTask = Task {
            do {
                let result = try await searchMoviesUseCase.execute(query: query, page: 1)
                
                if !Task.isCancelled {
                    movies = result.results
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
}
