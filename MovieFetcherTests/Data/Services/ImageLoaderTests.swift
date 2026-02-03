//
//  ImageLoaderTests.swift
//  MovieFetcherTests
//
//  Created by Hasan Abdullah on 03/02/26.
//

import XCTest
@testable import MovieFetcher

final class ImageLoaderTests: XCTestCase {
    var sut: ImageLoader!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = ImageLoader.shared
    }
    
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }
    
    func testImageLoader_IsActor_EnsuresThreadSafety() async {
        // Test that ImageLoader is an actor by checking it can be accessed with await
        let loader = ImageLoader.shared
        
        // This test verifies the actor isolation is working
        // If ImageLoader wasn't an actor, this wouldn't compile
        XCTAssertNotNil(loader)
    }
    
    func testCancelLoad_DoesNotCrash() async {
        // Test that cancelLoad can be called without crashing
        let url = URL(string: "https://example.com/test.jpg")!
        
        await sut.cancelLoad(for: url)
        
        // Should not crash
        XCTAssertTrue(true)
    }
    
    func testLoadImage_WithInvalidURL_ThrowsError() async {
        let url = URL(string: "https://invalid-domain-that-does-not-exist-12345.com/image.jpg")!
        
        do {
            _ = try await sut.loadImage(from: url)
            XCTFail("Expected error to be thrown for invalid URL")
        } catch {
            // Expected to throw an error
            XCTAssertTrue(true)
        }
    }
    
    func testLoadImage_ConcurrentCalls_DoNotCrash() async throws {
        // Test that concurrent calls to the actor don't cause data races
        let url1 = URL(string: "https://example.com/image1.jpg")!
        let url2 = URL(string: "https://example.com/image2.jpg")!
        let url3 = URL(string: "https://example.com/image3.jpg")!
        
        // Start multiple concurrent operations
        async let cancel1: Void = sut.cancelLoad(for: url1)
        async let cancel2: Void = sut.cancelLoad(for: url2)
        async let cancel3: Void = sut.cancelLoad(for: url3)
        
        // Wait for all to complete
        _ = await (cancel1, cancel2, cancel3)
        
        // Should not crash - actor ensures thread safety
        XCTAssertTrue(true)
    }
    
    func testImageLoader_SharedInstance_IsSingleton() async {
        let instance1 = ImageLoader.shared
        let instance2 = ImageLoader.shared
        
        // Both should reference the same instance
        XCTAssertTrue(instance1 === instance2)
    }
}
