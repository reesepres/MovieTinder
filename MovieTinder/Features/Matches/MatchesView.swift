//
//  Matches.swift.swift
//  MovieTinder
//
//  Created by Huthaifa Mohammad on 12/5/25.
//
import SwiftUI
import TMDb
struct MatchesView: View {
    let movies: [MovieListItem]
    let onRestart: () -> Void
    let onExit: () -> Void
    
    
    @State private var randomMatch: RandomMatch? = nil
    @State private var selectedMovie: MovieListItem? = nil
    @State private var showingAlert : Bool = false

    var body: some View {
        let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
        ZStack {
            Image("BackgroundImage")
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


                CarouselView(
                    movies: movies,
                    onPosterTapped: { movie in
                        selectedMovie = movie
                    }
                )
                VStack(){
                    HStack(spacing: 15) {
                        Button("Run-Off", action: onRestart)
                            .matchButtonStyle()
                        Button("Random"){
                            if let movie = movies.randomElement() {
                                randomMatch = RandomMatch(movie: movie)
                            }
                        }
                        .matchButtonStyle()
                }
                    Button("All Done!"){
                        
                        showingAlert = true
                    }
                        .matchButtonStyle()
                       .alert(isPresented: $showingAlert) {
                           Alert(
                               title: Text("Important Question"),
                               message: Text("You will lose these results and start with different movies !"),
                               primaryButton: .destructive(Text("All Done")) {
                                   // Action for "Delete"
                                   onExit()
                               },
                               secondaryButton: .cancel() {
                                   // Action for "Cancel"
                                   print("User cancelled.")
                               }
                           )
                       }

                    
                }.padding(45)
                Spacer(minLength: 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
        }
        .sheet(item: $randomMatch){ match in
            MatchView(movie: match.movie, onExit: {
                randomMatch = nil
                onExit()
            })
        }

        .sheet(item: $selectedMovie) { movie in
            DetailedPosterCardView(movie: movie)
                .presentationBackground(Color(white: 1))
        }
    }
}



struct RandomMatch: Identifiable {
    let id = UUID()
    let movie: MovieListItem
}

#Preview {
    MatchesView(
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
