# MovieFetcher

A native iOS application for searching and discovering movies using The Movie Database (TMDb) API.

## Features

- Movie search with real-time results
- Movie details with posters, ratings, and descriptions
- Favorites management with persistent storage
- Offline caching with pagination support
- Infinite scroll pagination
- Clean Architecture with MVVM pattern


## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+
- TMDb API Key

## Setup Instructions

### 1. Get TMDb API Key
1. Visit [The Movie Database](https://www.themoviedb.org/)
2. Create a free account
3. Go to Settings → API
4. Request an API key (v3 auth)

### 2. Configure API Key
1. Open `MovieFetcher/Data/Network/APIConfiguration.swift`
2. Replace `YOUR_API_KEY_HERE` with your TMDb API key:
```swift
static let apiKey = "your_actual_api_key"
```

### 3. Build and Run
1. Open `MovieFetcher.xcodeproj`
2. Select a simulator or device
3. Press `Cmd + R` to build and run

## Running Tests

Run all tests:
```bash
Cmd + U
```

Or via command line:
```bash
xcodebuild test -scheme MovieFetcher -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Technologies Used

- Swift 5.7+
- UIKit
- Core Data
- Combine
- Clean Architecture with MVVM

## License

This project is available for educational and personal use.

Movie data provided by [The Movie Database (TMDb)](https://www.themoviedb.org/)
