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

    func fetchDiscoveredMovies(filteredBy filter: MovieFilter) async {
        do {
            var collected: [MovieListItem] = []
            var page = Int.random(in: 1...500)

            while collected.count < 10 && page <= 500 {
                let response = try await tmdbClient.discover.movies(page: page)

                let filtered = response.results.filter { movie in
                    let rating = movie.voteAverage ?? 0
                    let year = Calendar.current.dateComponents([.year],
                                    from: movie.releaseDate ?? Date(timeIntervalSince1970: 0)).year ?? 0
                    let language = movie.originalLanguage
                    let posterPath = movie.posterPath

                    return rating >= filter.minRating &&
                           rating <= filter.maxRating &&
                           year >= filter.startYear &&
                           year <= filter.endYear &&
                           (filter.language.isEmpty || language == filter.language) &&
                           posterPath != nil
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
