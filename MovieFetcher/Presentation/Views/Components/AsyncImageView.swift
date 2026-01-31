//
//  AsyncImageView.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import UIKit

final class AsyncImageView: UIView {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let placeholderImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray3
        iv.image = UIImage(systemName: "photo")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var currentTask: Task<Void, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(imageView)
        addSubview(placeholderImageView)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            placeholderImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 40),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 40),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func loadImage(from url: URL?, imageLoader: ImageLoaderProtocol) {
        currentTask?.cancel()
        imageView.image = nil
        placeholderImageView.isHidden = false
        
        guard let url = url else {
            activityIndicator.stopAnimating()
            return
        }
        
        activityIndicator.startAnimating()
        
        currentTask = Task {
            do {
                let imageData = try await imageLoader.loadImage(from: url)
                if !Task.isCancelled {
                    await MainActor.run {
                        if let uiImage = ImageDataAdapter.toUIImage(from: imageData) {
                            self.imageView.image = uiImage
                            self.placeholderImageView.isHidden = true
                        }
                        self.activityIndicator.stopAnimating()
                    }
                }
            } catch {
                if !Task.isCancelled {
                    await MainActor.run {
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    
    func reset() {
        currentTask?.cancel()
        imageView.image = nil
        placeholderImageView.isHidden = false
        activityIndicator.stopAnimating()
    }
}

