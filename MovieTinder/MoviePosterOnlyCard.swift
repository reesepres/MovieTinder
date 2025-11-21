//
//  MoviePosterOnlyCard.swift
//  MovieTinder
//
//  Created by Reese Preston on 11/19/25.
//

import SwiftUI
import TMDb

struct MoviePosterOnlyCard: View {
    let movie: MovieListItem

    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: 300)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)

                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)

                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}
extension MoviePosterOnlyCard {
    private var posterURL: URL? {
        if let path = movie.posterPath?.path {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        return nil
    }
}
