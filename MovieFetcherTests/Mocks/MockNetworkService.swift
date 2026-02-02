//
//  MockNetworkService.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 03/02/26.
//

import Foundation

final class MockNetworkService: NetworkServiceProtocol {
    var result: Any?
    var shouldThrowError = false
    var errorToThrow: Error = NetworkError.noData
    var requestCallCount = 0
    var lastEndpoint: APIEndpoint?
    
    func request<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        requestCallCount += 1
        lastEndpoint = endpoint
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        guard let result = result as? T else {
            throw NetworkError.decodingError
        }
        
        return result
    }
}
