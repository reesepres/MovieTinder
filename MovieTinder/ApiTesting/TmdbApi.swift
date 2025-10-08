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

    @Published var discoveredMovies: [MovieListItem] = []
    @Published var fightClubDetails: Movie?

    func fetchDiscoveredMovies() async {
        do {
            let movies = try await tmdbClient.discover.movies().results
            self.discoveredMovies = movies
        } catch {
            print("Error discovering movies: \(error)")
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
