//
//  APIConfiguration.swift
//  MovieFetcher
//
//  Created by Hasan Abdullah on 31/01/26.
//

import Foundation

struct APIConfiguration {
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = "7b9d07fca6df524132abd06847d88744"
}

enum APIEndpoint {
    case searchMovies(query: String, page: Int)
    
    var path: String {
        switch self {
        case .searchMovies:
            return "/search/movie"
        }
    }
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem(name: "api_key", value: APIConfiguration.apiKey)]
        
        switch self {
        case .searchMovies(let query, let page):
            items.append(URLQueryItem(name: "query", value: query))
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        
        return items
    }
    
    func url() -> URL? {
        var components = URLComponents(string: APIConfiguration.baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}
