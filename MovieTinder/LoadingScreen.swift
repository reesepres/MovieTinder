//
//  LoadingScreen.swift
//  MovieTinder
//
//  Created by Owen Blanchard on 12/7/25.
//

import SwiftUI
import TMDb

struct LoadingScreen: View {
    let playerCount: Int
    let filter: MovieFilter
    let clientManager: TmdbApi
    
    @State private var isReady: Bool = false
    @State private var movies: [MovieListItem] = []
    @State private var players: [Player] = []
    @Environment(\.dismiss) private var dismiss
    
    let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
    
    var body: some View {
        ZStack {
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            if !isReady {
                VStack(spacing: 30) {
                    ProgressView()
                        .scaleEffect(2.0)
                        .tint(.white)
                    
                    Text("Loading Movies...")
                        .font(.custom("ArialRoundedMTBold", size: 32))
                        .foregroundColor(.white)
                    
                    Text("Please wait while we prepare your movie selection")
                        .font(.custom("ArialRoundedMTBold", size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    if clientManager.availableMovieCount > 0 {
                        Text("\(clientManager.availableMovieCount) movies loaded")
                            .font(.custom("ArialRoundedMTBold", size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $isReady) {
            GameFlowView(players: players, movies: movies)
        }
        .onAppear {
            loadMovies()
        }
    }
    
    private func loadMovies() {
        players = makePlayers(count: playerCount)
        
        Task {
            let moviesNeeded = playerCount * 10
            
            // Wait for minimum movies needed
            await clientManager.waitForMinimumMovies(count: moviesNeeded)
            
            // Get movies from cache
            let cachedMovies = clientManager.getMoviesFromCache(count: moviesNeeded)
            
            if cachedMovies.count >= moviesNeeded {
                self.movies = cachedMovies
            } else {
                // Fallback: fetch fresh if cache doesn't have enough
                await clientManager.fetchDiscoveredMovies(filteredBy: filter)
                self.movies = clientManager.discoveredMovies
                
                // If still not enough, pad with what we have
                if self.movies.count < moviesNeeded {
                    let available = clientManager.getMoviesFromCache(count: 100)
                    self.movies = Array(available.prefix(moviesNeeded))
                }
            }
            
            // Small delay to show the loading screen briefly even if fast
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            isReady = true
        }
    }
}
