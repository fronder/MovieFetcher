//
//  FavoritesViewController.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 02/02/26.
//

import UIKit
import Combine

final class FavoritesViewController: UIViewController {
    private let viewModel: FavoritesViewModel
    private var cancellables = Set<AnyCancellable>()
    
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
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No favorite movies yet"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var onMovieTap: ((Movie) -> Void)?
    
    init(viewModel: FavoritesViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
    
    private func bindViewModel() {
        viewModel.$favoriteMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.tableView.reloadData()
                self?.emptyStateLabel.isHidden = !movies.isEmpty
            }
            .store(in: &cancellables)
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = viewModel.favoriteMovies[indexPath.row]
        cell.configure(with: movie, isFavorite: true, imageLoader: ImageLoader.shared)
        cell.onFavoriteToggle = { [weak self] in
            self?.viewModel.removeFromFavorites(movieId: movie.id)
        }
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = viewModel.favoriteMovies[indexPath.row]
        onMovieTap?(movie)
    }
}

extension FavoritesViewController {
    private func setupUI() {
        title = "Favorites"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
