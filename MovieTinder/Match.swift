//
//  Match.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/22/25.
//

import SwiftUI
import TMDb

// MARK: - Single Match Screen
struct Match: View {
    let movie: MovieListItem?
    let onExit: () -> Void

    var body: some View {
        let navy = Color(red: 15/225, green: 34/255, blue: 116/225)
        ZStack {
            Image("MatchBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("MATCH!")
                    .font(.system(size: 60, design: .serif))
                    .padding(.top, 40)
//<<<<<<< Updated upstream
//
//                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie?.posterPath?.absoluteString ?? "")")) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                            .frame(height: 500)
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .scaledToFit()
//                            .frame(maxWidth: .infinity)
//                            .cornerRadius(20)
//                            .shadow(radius: 10)
//                            .padding(.horizontal)
//                    case .failure:
//                        Image(systemName: "photo")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(maxHeight: 300, alignment: .center)
//
//                            .foregroundColor(.gray)
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
//
//=======

                // Poster Image
                if let poster = movie?.posterPath {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(poster.absoluteString)")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 400)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300)
                                .cornerRadius(20)
                                .shadow(radius: 10)
                                .padding(.horizontal)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 400)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                // Title and Overview
                Text(movie!.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 8)
                    .foregroundColor(.black)

                Text(movie!.overview)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.black)

                Spacer()

//>>>>>>> Stashed changes
                Button("All Done!", action: onExit)
                    .font(.headline)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(navy)
                    .foregroundColor(.white)
                    .cornerRadius(12)

                Spacer(minLength: 40)
            }
            .padding()
        }
    }
}

// MARK: - Multiple Matches Screen
struct Matches: View {
    let movies: [MovieListItem]
    let onRestart: () -> Void
    let onExit: () -> Void

    var body: some View {
        let navy = Color(red: 15/225, green: 34/255, blue: 116/225)
        ZStack {
            Image("MatchesBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("MATCHES")
                    .font(.system(size: 42, design: .serif))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                    .foregroundColor(.black)

                ScrollView {
                    LazyVStack(spacing: 25) {
                        ForEach(movies, id: \.id) { movie in
                            VStack(spacing: 10) {
                                // Poster image with fixed aspect ratio
                                if let poster = movie.posterPath {
                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(poster.absoluteString)")) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(height: 300)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()   // ✅ keeps proportions
                                                .frame(maxWidth: UIScreen.main.bounds.width * 0.85)
                                                .cornerRadius(16)
                                                .shadow(radius: 8)
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 300)
                                                .foregroundColor(.gray)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }

                                // Movie title
                                Text(movie.title)
                                    .font(.title3.bold())
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.85)

                                // Overview text
                                Text(movie.overview)
                                    .font(.footnote)
                                    .foregroundColor(.black.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.85)
                            }
                            .padding(.bottom, 10)
                        }
                    }
                    .padding(.vertical, 20)
                }

                Spacer(minLength: 10)

                // Buttons
                VStack(spacing: 15) {
                    Button("Run-Off", action: onRestart)
                        .font(.headline)
                        .padding()
                        .frame(width: 220, height: 55)
                        .background(navy)
                        .foregroundColor(.white)
                        .cornerRadius(12)

                    Button("All Done!", action: onExit)
                        .font(.headline)
                        .padding()
                        .frame(width: 220, height: 55)
                        .background(navy)
                        .foregroundColor(.white)
                        .cornerRadius(12)

                    Button("Random!") {
                        // Optional: Random selection logic
                    }
                    .font(.headline)
                    .padding()
                    .frame(width: 220, height: 55)
                    .background(navy)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                Spacer(minLength: 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
        }
    }
}

#Preview {
    Match(
        movie: MovieListItem(
            id: 1,
            title: "Inception",
            originalTitle: "Inception",
            originalLanguage: "en",
            overview: "A skilled thief uses dream-sharing technology to infiltrate targets' subconscious.",
            genreIDs: [28, 878],
            releaseDate: Date(timeIntervalSince1970: 1279257600),
            posterPath: nil
        ),
        onExit: {}
    )
}
