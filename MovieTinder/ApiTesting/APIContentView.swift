//
//  APIContentView.swift
//  MovieTinder
//
//  Created by Owen Blanchard on 10/6/25.
//

import SwiftUI
import TMDb

struct APIContentView: View {
    @StateObject private var clientManager = TmdbApi()

    var body: some View {
        VStack(spacing: 20) {
            Button("Fetch Discovered Movies") {
                Task {
                    await clientManager.fetchDiscoveredMovies() // call to create list of strings, accessed from class variable "clientManager.discoveredMovies" @Huthaifa
                }
            }

            Button("Fetch Fight Club") {
                Task {
                    await clientManager.fetchFightClubDetails()
                }
            }

            if let fightClub = clientManager.fightClubDetails {
                Text("Fight Club: \(fightClub.title)")
                    .font(.headline)
            }

            List(clientManager.discoveredMovies, id: \.self) {
                movie in Text(movie)
            }
        }
        .padding()
    }
}
#Preview{
    APIContentView()
}
