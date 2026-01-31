//
//  MovieTableViewCell.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    private let posterImageView = AsyncImageView()
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Movie Title"
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "01.02.2022"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.reset()
        titleLabel.text = nil
        releaseDateLabel.text = nil
    }
}
