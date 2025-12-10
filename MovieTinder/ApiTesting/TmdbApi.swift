//
//  TmdbApi.swift
//  MovieTinder
//
//  Created by Owen Blanchard on 10/6/25.
//

import SwiftUI
import Combine
import TMDb

@MainActor
class TmdbApi: ObservableObject {
    private let tmdbClient = TMDbClient(apiKey: "548556ec9c8ef03ab9b6cd54872865a2")

    @Published var discoveredTitles: [String] = []
    @Published var discoveredMovies: [MovieListItem] = []
    @Published var fightClubDetails: Movie?
    @Published var isLoading: Bool = false
    @Published var availableMovieCount: Int = 0
    
    // Preloaded movie cache
    private var movieCache: [MovieListItem] = []
    private var cacheFilter: MovieFilter?
    private var cacheTask: Task<Void, Never>?

    func fetchDiscoveredMovies() async {
        do {
            let page = Int.random(in: 1...500)
            let response = try await tmdbClient.discover.movies(page: page)
            let movies = Array(response.results.prefix(10))
            self.discoveredTitles = movies.map { $0.title }
            self.discoveredMovies = movies
        } catch {
            print("Error discovering movies: \(error)")
        }
    }

    func startPreloadingMovies(filter: MovieFilter) {
        // Cancel any existing preload task
        cacheTask?.cancel()
        
        // Check if we already have a cache for this exact filter
        if let cachedFilter = cacheFilter, cachedFilter == filter, !movieCache.isEmpty {
            print("Using existing cache with \(movieCache.count) movies")
            return
        }
        
        // Start new preload task
        cacheTask = Task {
            await preloadMoviesInBackground(filter: filter)
        }
    }
    
    private func preloadMoviesInBackground(filter: MovieFilter) async {
        print("Starting background preload for filter: \(filter)")
        isLoading = true
        
        do {
            var collected: [MovieListItem] = []
            var seenIDs = Set<Int>()
            let startPage = Int.random(in: 1...400)
            var page = startPage
            let maxPages = 100 // Limit search to prevent infinite loops
            var pagesChecked = 0

            while collected.count < 50 && pagesChecked < maxPages {
                // Check if task was cancelled
                if Task.isCancelled {
                    print("Preload task cancelled")
                    isLoading = false
                    return
                }
                
                let response = try await tmdbClient.discover.movies(page: page)

                let filtered = response.results.filter { movie in
                    guard !seenIDs.contains(movie.id) else { return false }
                    
                    let rating = movie.voteAverage ?? 0
                    let year = Calendar.current.dateComponents([.year],
                                    from: movie.releaseDate ?? Date(timeIntervalSince1970: 0)).year ?? 0
                    let language = movie.originalLanguage
                    let posterPath = movie.posterPath
                    let isAdult = movie.isAdultOnly

                    return rating >= filter.minRating &&
                           rating <= filter.maxRating &&
                           year >= filter.startYear &&
                           year <= filter.endYear &&
                           (filter.language.isEmpty || language == filter.language) &&
                           posterPath != nil &&
                           isAdult == false
                }

                for movie in filtered {
                    seenIDs.insert(movie.id)
                }
                
                collected.append(contentsOf: filtered)

                if page >= (response.totalPages ?? 500) || page >= 500 {
                    page = 1 // Wrap around
                } else {
                    page += 1
                }
                
                pagesChecked += 1
                
                // Update available count periodically
                if collected.count >= 10 {
                    availableMovieCount = collected.count
                }
            }

            // Store in cache
            movieCache = collected
            cacheFilter = filter
            availableMovieCount = collected.count
            isLoading = false
            
            print("Preload complete: \(collected.count) movies cached")

        } catch {
            print("Error preloading movies: \(error)")
            isLoading = false
        }
    }
    
    func getMoviesFromCache(count: Int) -> [MovieListItem] {
        guard !movieCache.isEmpty else {
            print("Warning: Cache is empty")
            return []
        }
        
        // Shuffle and take requested count
        let shuffled = movieCache.shuffled()
        let result = Array(shuffled.prefix(count))
        print("Retrieved \(result.count) movies from cache")
        return result
    }
    
    func waitForMinimumMovies(count: Int) async {
        // If we already have enough movies, return immediately
        if movieCache.count >= count {
            return
        }
        
        // Wait for loading to complete or until we have enough movies
        while isLoading && movieCache.count < count {
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        }
    }

    func fetchDiscoveredMovies(filteredBy filter: MovieFilter) async {
        // Use cache if available
        if let cachedFilter = cacheFilter, cachedFilter == filter, movieCache.count >= 10 {
            let movies = getMoviesFromCache(count: 10)
            self.discoveredTitles = movies.map { $0.title }
            self.discoveredMovies = movies
            return
        }
        
        // Otherwise fetch fresh
        do {
            var collected: [MovieListItem] = []
            var seenIDs = Set<Int>()
            var page = Int.random(in: 1...500)

            while collected.count < 10 && page <= 500 {
                let response = try await tmdbClient.discover.movies(page: page)

                let filtered = response.results.filter { movie in
                    guard !seenIDs.contains(movie.id) else { return false }
                    
                    let rating = movie.voteAverage ?? 0
                    let year = Calendar.current.dateComponents([.year],
                                    from: movie.releaseDate ?? Date(timeIntervalSince1970: 0)).year ?? 0
                    let language = movie.originalLanguage
                    let posterPath = movie.posterPath
                    let adultOnly = movie.isAdultOnly ?? true

                    return rating >= filter.minRating &&
                           rating <= filter.maxRating &&
                           year >= filter.startYear &&
                           year <= filter.endYear &&
                           (filter.language.isEmpty || language == filter.language) &&
                           posterPath != nil &&
                           !adultOnly
                }

                for movie in filtered {
                    seenIDs.insert(movie.id)
                }
                
                collected.append(contentsOf: filtered)

                if page == response.totalPages { break }
                page += 1
            }

            let firstTen = Array(collected.prefix(10))
            self.discoveredTitles = firstTen.map { $0.title }
            self.discoveredMovies = firstTen

        } catch {
            print("Error discovering filtered movies: \(error)")
        }
    }


    func fetchFightClubDetails() async {
        do {
            let fightClub = try await tmdbClient.movies.details(forMovie: 550)
            self.fightClubDetails = fightClub
        } catch {
            print("Error fetching Fight Club details: \(error)")
        }
    }
}
