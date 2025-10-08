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
                    await clientManager.fetchDiscoveredMovies()
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

            List(clientManager.discoveredMovies, id: \.id) { movie in
                Text(movie.title)
            }
        }
        .padding()
    }
}
#Preview{
    APIContentView()
}
