//
//  MovieSearchViewController.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 30/01/26.
//

import UIKit
import Combine

final class MovieSearchViewController: UIViewController {
    private let viewModel: MovieSearchViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search movies..."
        return controller
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 144
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Search for movies"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var onMovieTap: ((Movie) -> Void)?
    
    init(viewModel: MovieSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.tableView.reloadData()
                self?.emptyStateLabel.isHidden = !movies.isEmpty || self?.viewModel.isLoading == true
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let error = errorMessage {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MovieSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = viewModel.movies[indexPath.row]
        let isFavorite = viewModel.isFavorite(movieId: movie.id)
        cell.configure(with: movie, isFavorite: isFavorite, imageLoader: ImageLoader.shared)
        cell.onFavoriteToggle = { [weak self] in
            self?.viewModel.toggleFavorite(movie: movie)
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        return cell
    }
}

extension MovieSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = viewModel.movies[indexPath.row]
        onMovieTap?(movie)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = viewModel.movies.count - 1
        if indexPath.row == lastIndex && viewModel.hasMorePages {
            Task {
                await viewModel.loadMoreMovies()
            }
        }
    }
}

extension MovieSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQuery = ""
    }
}

extension MovieSearchViewController {
    private func setupUI() {
        title = "Movies"
        view.backgroundColor = .systemBackground
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
