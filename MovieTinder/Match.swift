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
        let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
        ZStack {
            Image("MatchBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .foregroundColor(navy)

            VStack(spacing: 20) {
                Text("MATCH!")
                    .font(.custom("ArialRoundedMTBold", size: 60))
                    .padding(.top, 40)
                    .foregroundColor(navy)
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
                VStack(spacing: 24){
                    if let movie {
                        MoviePosterCard(movie: movie)
                    } else {
                        Text("No movie available")
                            .font(.custom("ArialRoundedMTBold", size: 30))
                            .foregroundColor(navy)
                    }
                }
                .padding(.top)
                .frame(maxWidth: UIScreen.main.bounds.width)

                Spacer()

//>>>>>>> Stashed changes
                Button("All Done!", action: onExit)
                    .font(.custom("ArialRoundedMTBold", size: 30))
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


struct RandomMatch: Identifiable {
    let id = UUID()
    let movie: MovieListItem
}

// MARK: - Multiple Matches Screen
struct Matches: View {
    let movies: [MovieListItem]
    let onRestart: () -> Void
    let onExit: () -> Void
    
    @State private var randomMatch: RandomMatch? = nil

    var body: some View {
        let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
        ZStack {
            Image("MatchesBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("MATCHES")
                    .font(.custom("ArialRoundedMTBold", size: 50))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                    .foregroundColor(navy)

               Carousel(movies: movies)
                
//                ScrollView {
//                    LazyVStack(spacing: 25) {
//                        ForEach(movies, id: \.id) { movie in
//                            VStack(spacing: 10) {
//                                // Poster image with fixed aspect ratio
//                                if let poster = movie.posterPath {
//                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(poster.absoluteString)")) { phase in
//                                        switch phase {
//                                        case .empty:
//                                            ProgressView()
//                                                .frame(height: 300)
//                                        case .success(let image):
//                                            image
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(maxWidth: UIScreen.main.bounds.width * 0.85)
//                                                .cornerRadius(16)
//                                                .shadow(radius: 8)
//                                        case .failure:
//                                            Image(systemName: "photo")
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(height: 300)
//                                                .foregroundColor(.gray)
//                                        @unknown default:
//                                            EmptyView()
//                                        }
//                                    }
//                                }
//
//                                // Movie title
//                                Text(movie.title)
//                                    .font(.custom("ArialRoundedMTBold", size: 30))
//                                    .foregroundColor(navy)
//                                    .multilineTextAlignment(.center)
//                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.85)
//
//                                // Overview text
//                                Text(movie.overview)
//                                    .font(.footnote)
//                                    .foregroundColor(navy.opacity(0.8))
//                                    .multilineTextAlignment(.center)
//                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.85)
//                            }
//                            .padding(.bottom, 10)
//                        }
//                    }
//                    .padding(.vertical, 20)
//                }
//
//                Spacer(minLength: 10)

                // Buttons
                VStack(spacing: 15) {
                    Button("Run-Off", action: onRestart)
                        .font(.custom("ArialRoundedMTBold", size: 30))
                        .padding()
                        .frame(width: 220, height: 55)
                        .background(navy)
                        .foregroundColor(.white)
                        .cornerRadius(12)

                    Button("All Done!", action: onExit)
                        .font(.custom("ArialRoundedMTBold", size: 30))
                        .padding()
                        .frame(width: 220, height: 55)
                        .background(navy)
                        .foregroundColor(.white)
                        .cornerRadius(12)

                    Button("Random"){
                        if let movie = movies.randomElement() {
                            randomMatch = RandomMatch(movie: movie)
                        }
                    }
                    .font(.custom("ArialRoundedMTBold", size: 30))
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
        .sheet(item: $randomMatch){ match in
            Match(movie: match.movie, onExit: {
                randomMatch = nil
                onExit()
            })
        }
    }
}

#Preview {
    Matches(
        movies: [
            MovieListItem(
                id: 1,
                title: "Inception",
                originalTitle: "Inception",
                originalLanguage: "en",
                overview: "A skilled thief uses dream-sharing technology to infiltrate targets' subconscious.",
                genreIDs: [28, 878],
                releaseDate: Date(timeIntervalSince1970: 1279257600),
                posterPath: URL(string: "https://image.tmdb.org/t/p/w500//qwerty.jpg")
            ),
            MovieListItem(
                id: 2,
                title: "La La Land",
                originalTitle: "La La Land",
                originalLanguage: "en",
                overview: "A jazz pianist and an aspiring actress pursue their dreams in Los Angeles.",
                genreIDs: [35, 18, 10749],
                releaseDate: Date(timeIntervalSince1970: 1481846400),
                posterPath: URL(string: "https://image.tmdb.org/t/p/w500//asdfgh.jpg")
            )
        ],
        onRestart: {},
        onExit: {}
    )
}
