//
//  ImageLoader.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import Foundation

actor ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, NSData>()
    private var runningTasks = [URL: Task<ImageData, Error>]()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }
    
    func loadImage(from url: URL) async throws -> ImageData {
        if let cachedData = cache.object(forKey: url as NSURL) as Data? {
            return ImageData(data: cachedData, url: url)
        }
        
        if let existingTask = runningTasks[url] {
            return try await existingTask.value
        }
        
        let task = Task<ImageData, Error> {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
            
            let imageData = ImageData(data: data, url: url)
            cache.setObject(data as NSData, forKey: url as NSURL)
            
            self.removeTask(for: url)
            
            return imageData
        }
        
        runningTasks[url] = task
        return try await task.value
    }
    
    func cancelLoad(for url: URL) {
        runningTasks[url]?.cancel()
        runningTasks[url] = nil
    }
    
    private func removeTask(for url: URL) {
        runningTasks[url] = nil
    }
}
