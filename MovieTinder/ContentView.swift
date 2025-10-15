//
//  ContentView.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var clientManager = TmdbApi()
    @State private var goToNumber = false
    @State private var goToReady = false
    @State private var players: [Player] = []
    @State private var movies: [String] = []

    var body: some View {
        let navy = Color(red: 15/255, green: 34/255, blue: 116/255)

        NavigationStack {
            ZStack {
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    Text("Movie Tinder")
                        .font(.system(size: 60, design: .serif))
                        .padding(.top, 60)
                    Spacer()

                    Button {
                        goToNumber = true
                    } label: {
                        Text("Pick a Movie")
                            .font(.system(size: 30, weight: .bold))
                            .padding()
                            .frame(width: 250, height: 100)
                            .background(navy)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 120)
                }
            }
            // Step 1: Go to NumberPeople
            .navigationDestination(isPresented: $goToNumber) {
                NumberPeople { count in
                    self.players = makePlayers(count: count)
                    Task {
                        await clientManager.fetchDiscoveredMovies()
                        self.movies = Array(clientManager.discoveredMovies[..<10])
                        goToReady = true
                    }
                }
            }
            // Step 2: Go to ReadyToPick
            .navigationDestination(isPresented: $goToReady) {
                ReadyToPick(players: players, movies: movies)
            }
        }
    }
}

#Preview {
    ContentView()
}
