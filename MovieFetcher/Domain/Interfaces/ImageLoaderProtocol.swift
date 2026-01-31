//
//  ImageLoaderProtocol.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import Foundation

protocol ImageLoaderProtocol {
    func loadImage(from url: URL) async throws -> ImageData
    func cancelLoad(for url: URL)
}
