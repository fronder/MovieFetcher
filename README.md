# MovieFetcher

A native iOS application for searching and discovering movies using The Movie Database (TMDb) API. Built with Swift, UIKit, and Core Data, following Clean Architecture principles.

## Features

### Core Features
- **Movie Search**: Search for movies by title with real-time results
- **Two-Screen Interface**: Search screen and detailed movie information screen
- **Rich Movie Display**: Shows movie posters, titles, release dates, and overviews
- **Favorites Management**: Save and manage favorite movies with persistent storage
- **Offline Caching**: Automatically caches search results for offline access
- **Pagination**: Infinite scroll to load more search results
- **Error Handling**: Graceful error handling with user-friendly feedback

### Architecture
- **Clean Architecture**: Separation of concerns with Domain, Data, and Presentation layers
- **MVVM Pattern**: ViewModel-based presentation layer
- **Dependency Injection**: Modular and testable code structure
- **Protocol-Oriented**: Flexible and maintainable design

## Use Cases

### 1. Search for Movies
**Actor**: User  
**Precondition**: User has internet connection  
**Flow**:
1. User opens the app and sees the search screen
2. User taps on the search bar
3. User types a movie title (e.g., "Inception")
4. System displays loading indicator
5. System fetches results from TMDb API
6. System caches the results locally
7. System displays movies in a table view with poster, title, and release date

**Postcondition**: Search results are displayed and cached for offline use

---

### 2. View Movie Details
**Actor**: User  
**Precondition**: User has performed a search and results are displayed  
**Flow**:
1. User taps on a movie from the search results
2. System navigates to the detail screen
3. System displays comprehensive movie information:
   - Full-size poster image
   - Movie title
   - Release date (formatted)
   - Vote average and vote count
   - Popularity score
   - Full overview/description

**Postcondition**: User views detailed information about the selected movie

---

### 3. Load More Search Results (Pagination)
**Actor**: User  
**Precondition**: User has performed a search with multiple pages of results  
**Flow**:
1. User scrolls to the bottom of the search results
2. System detects user reached the last visible cell
3. System automatically loads the next page of results
4. System appends new results to the existing list
5. System caches the new page of results

**Postcondition**: Additional movies are loaded and displayed

---

### 4. Access Cached Movies Offline
**Actor**: User  
**Precondition**: User has previously searched for movies while online  
**Flow**:
1. User opens the app without internet connection
2. User types a previously searched query
3. System checks local Core Data cache
4. System retrieves cached results for that query and page
5. System displays cached movies instantly

**Postcondition**: User can browse previously viewed movies without internet

---

### 5. Clear Search
**Actor**: User  
**Precondition**: User has active search results displayed  
**Flow**:
1. User taps the clear button (X) in the search bar
2. System clears the search query
3. System removes all displayed results
4. System shows empty state message: "Search for movies"

**Postcondition**: Search is cleared and ready for new query

---

### 6. Handle Network Errors
**Actor**: User  
**Precondition**: User attempts to search while having network issues  
**Flow**:
1. User enters a search query
2. System attempts to fetch data from API
3. Network request fails
4. System displays error alert with descriptive message
5. User taps "OK" to dismiss alert
6. System falls back to cached results if available

**Postcondition**: User is informed of the error and can continue using cached data

---

### 7. Navigate Back from Details
**Actor**: User  
**Precondition**: User is viewing movie details  
**Flow**:
1. User taps the back button in navigation bar
2. System navigates back to search results
3. System preserves the search results and scroll position

**Postcondition**: User returns to search screen with results intact

## Technical Architecture

### Layers

#### 1. Domain Layer
- **Entities**: `Movie`, `MovieSearchResult`
- **Use Cases**: `SearchMoviesUseCase`, `ManageFavoritesUseCase`
- **Protocols**: `MovieRepositoryProtocol`, `MovieCacheProtocol`, `FavoritesRepositoryProtocol`

#### 2. Data Layer
- **Repository**: `MovieRepository` (implements `MovieRepositoryProtocol`)
- **Network**: `NetworkService`, `APIEndpoint`, `APIConfiguration`
- **Cache**: `CoreDataMovieCache`, `CoreDataManager`
- **Persistence**: `MovieEntity` (Core Data model)

#### 3. Presentation Layer
- **ViewModels**: `MovieSearchViewModel`, `MovieDetailViewModel`, `FavoritesViewModel`
- **Views**: `MovieSearchViewController`, `MovieDetailViewController`, `FavoritesViewController`
- **Cells**: `MovieTableViewCell`
- **Coordinators**: `AppCoordinator`

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+
- TMDb API Key

## Setup Instructions

### 1. Clone the Repository
```bash
git clone <repository-url>
cd MovieFetcher
```

### 2. Configure API Key
1. Open `APIConfiguration.swift`
2. Replace `YOUR_API_KEY_HERE` with your TMDb API key:
```swift
static let apiKey = "your_actual_api_key"
```

### 3. Get TMDb API Key
1. Visit [The Movie Database](https://www.themoviedb.org/)
2. Create a free account
3. Go to Settings → API
4. Request an API key
5. Copy your API key (v3 auth)

### 4. Open Project
```bash
open MovieFetcher.xcodeproj
```

### 5. Build and Run
- Select a simulator or device
- Press `Cmd + R` to build and run

## Testing

### Unit Tests
The project includes comprehensive unit tests for:
- `MovieRepository`: Network and cache integration
- Use Cases: Business logic validation (`SearchMoviesUseCase`, `ManageFavoritesUseCase`)
- ViewModels: Presentation logic (`MovieSearchViewModel`, `FavoritesViewModel`)

Run unit tests:
```bash
Cmd + U
```

Or run specific test:
```bash
xcodebuild test -scheme MovieFetcher -destination 'platform=iOS Simulator,name=iPhone 15'
```

## API Integration

### Endpoints Used
- **Search Movies**: `/search/movie`
  - Parameters: `query`, `page`, `api_key`
  - Returns: Paginated movie results

### Image URLs
- **Poster**: `https://image.tmdb.org/t/p/w500/{posterPath}`
- **Backdrop**: `https://image.tmdb.org/t/p/w780/{backdropPath}`

## Error Handling

The app handles various error scenarios:
- **Network Errors**: Connection issues, timeouts
- **API Errors**: Unauthorized (401), Server errors (5xx)
- **Decoding Errors**: Invalid JSON responses
- **No Data**: Empty search results

All errors are presented to users via alerts with clear messages.

## Caching Strategy

### Cache Implementation
- **Technology**: Core Data
- **Strategy**: Query + Page based caching
- **Persistence**: Automatic background saves
- **Retrieval**: Instant local lookup before network call

### Cache Benefits
1. **Offline Access**: View previously searched movies without internet
2. **Performance**: Instant results for repeated searches
3. **Data Efficiency**: Reduces API calls and bandwidth usage
4. **User Experience**: Seamless transition between online/offline modes

## Project Structure

```
MovieFetcher/
├── Application/
│   └── DependencyContainer.swift
├── Domain/
│   ├── Entities/
│   │   ├── Movie.swift
│   │   └── MovieSearchResult.swift
│   ├── Interfaces/
│   │   ├── MovieRepositoryProtocol.swift
│   │   └── MovieCacheProtocol.swift
│   └── UseCases/
│       └── SearchMoviesUseCase.swift
├── Data/
│   ├── Network/
│   │   ├── NetworkService.swift
│   │   ├── NetworkError.swift
│   │   ├── APIEndpoint.swift
│   │   └── APIConfiguration.swift
│   ├── Persistence/
│   │   ├── Cache/
│   │   │   ├── CoreDataMovieCache.swift
│   │   │   └── Manager/
│   │   │       └── CoreDataManager.swift
│   │   └── Entities/
│   │       ├── MovieEntity+CoreDataClass.swift
│   │       └── MovieEntity+CoreDataProperties.swift
│   ├── Repositories/
│   │   └── MovieRepository.swift
│   └── Services/
│       └── ImageLoader.swift
├── Presentation/
│   ├── ViewModels/
│   │   ├── MovieSearchViewModel.swift
│   │   └── MovieDetailViewModel.swift
│   ├── Views/
│   │   ├── MovieSearchViewController.swift
│   │   ├── MovieDetailViewController.swift
│   │   └── Cells/
│   │       └── MovieTableViewCell.swift
│   ├── Coordinators/
│   │   ├── Coordinator.swift
│   │   └── AppCoordinator.swift
│   └── Adapters/
│       └── ImageDataAdapter.swift
└── Resources/
    ├── MovieFetcher.xcdatamodeld
    ├── AppDelegate.swift
    └── SceneDelegate.swift
```

## Dependencies

### Native Frameworks
- **UIKit**: UI components and navigation
- **Combine**: Reactive programming for ViewModels
- **CoreData**: Local data persistence
- **Foundation**: Core Swift functionality

### No External Dependencies
This project uses only native iOS frameworks - no third-party dependencies required.

## Future Enhancements

### Completed Features
- ✅ **Favorites List**: Save and manage favorite movies with Core Data persistence

### Potential Features
- 🎬 **Movie Trailers**: Watch trailers within the app
- 🔔 **Notifications**: Alerts for new releases
- 🌙 **Dark Mode**: Enhanced dark mode support
- 🔄 **Pull to Refresh**: Manual refresh of search results
- 📊 **Advanced Filters**: Filter by genre, year, rating
- 👤 **User Profiles**: Personalized recommendations

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is available for educational and personal use.

## Acknowledgments

- Movie data provided by [The Movie Database (TMDb)](https://www.themoviedb.org/)
- This product uses the TMDb API but is not endorsed or certified by TMDb

## Contact

For questions or feedback, please open an issue in the repository.
