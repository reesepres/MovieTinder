//
//  Match.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/22/25.
//
import SwiftUI
import TMDb

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
            VStack {
                Text("MATCH!")
                    .font(.system(size: 60, design: .serif))
                    .padding(.top, 40)
                
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie?.posterPath?.absoluteString ?? "")")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 500)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .padding(.horizontal)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300, alignment: .center)
                            
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Button("All Done!", action: onExit)
                    .font(.headline)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(navy)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                Spacer()
            }.padding()
        }
    }
}

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
            VStack {
                Text("MATCHES")
                    .font(.system(size: 48, design: .serif))
                    .padding(.top, 40)

                Button("Run-Off", action: onRestart)
                    .font(.headline)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(navy)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                
                Button("All Done!", action: onExit)
                    .font(.headline)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(navy)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                
                Button("Random!") {
                    
                }
                    .font(.headline)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(navy)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                
            }.padding()
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
                overview: "Dream heist film.",
                genreIDs: [28, 878],
                releaseDate: Date(timeIntervalSince1970: 1279257600),
                posterPath: nil
            ),
            MovieListItem(
                id: 2,
                title: "Interstellar",
                originalTitle: "Interstellar",
                originalLanguage: "en",
                overview: "Explorers travel through a wormhole in search of a new home.",
                genreIDs: [12, 18, 878],
                releaseDate: Date(timeIntervalSince1970: 1415145600),
                posterPath: nil
            )
        ],
        onRestart: {},
        onExit: {}
    )
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
