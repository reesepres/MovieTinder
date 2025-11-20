//
//  Carousel.swift
//  MovieTinder
//
//  Created by Reese Preston on 11/19/25.
//

import SwiftUI
import TMDb
import Combine

struct Carousel: View {
    let movies: [MovieListItem]

    @State private var currentIndex: Int = 0

    //Scrolls every 3 seconds
    private let timer = Timer.publish(
        every: 3,
        on: .main,
        in: .common
    ).autoconnect()

    //Loops the list
    private var loopedMovies: [MovieListItem] {
        guard !movies.isEmpty else { return [] }
        return movies + movies + movies
    }

    //Starts in the middle of the looped movies
    private var middleStart: Int {
        movies.count
    }

    var body: some View {
        ZStack {
            if !loopedMovies.isEmpty {
                
                GeometryReader { _ in
                    //width of each poster
                    let cardWidth: CGFloat = 260
                    //space between posters
                    let spacing: CGFloat = 16
                    let step = cardWidth + spacing

                    
                    HStack(spacing: spacing) {
                        
                        ForEach(loopedMovies.indices, id: \.self) { index in
                            
                            MoviePosterOnlyCard(movie: loopedMovies[index])
                                //Size of each poster
                                .frame(width: cardWidth, height: 360)
                                //Center card is larger and side cards are smaller
                                .scaleEffect(index == currentIndex ? 1.0 : 0.9)
                                //Side posters opacity
                                .opacity(index == currentIndex ? 1.0 : 0.6)
                                //Change this if we want to be able to tap and "open" the posters
                                .allowsHitTesting(false)
                        }
                    }
                    .frame(height: 360)
                    .offset(x: -CGFloat(currentIndex) * step)
                }
            }
        }
        .frame(width: 300, height: 380)
        .padding(.vertical, 10)

        .onAppear {
            if !movies.isEmpty {
                currentIndex = middleStart
            }
        }

        .onReceive(timer) { _ in
            guard movies.count > 1 else { return }
            goToNext()
        }

        .onChange(of: currentIndex) { _, _ in
            normalizeIndexIfNeeded()
        }
    }

    //Scroll loops infinitly by snapping to middle
    private func normalizeIndexIfNeeded() {
        guard !movies.isEmpty else { return }
        
        let n = movies.count
        let middleEnd = 2 * n - 1

        //Make sure index is middle copy
        if currentIndex < middleStart || currentIndex > middleEnd {
            let logical = (currentIndex % n + n) % n
            let newIndex = middleStart + logical
            currentIndex = newIndex
        }
    }

    //go to next movie poster
    private func goToNext() {
        withAnimation(.easeInOut(duration: 0.35)) {
            currentIndex += 1
        }
    }
}

#Preview {
    Carousel(
        movies: [
            MovieListItem(
                id: 1,
                title: "Inception",
                originalTitle: "Inception",
                originalLanguage: "en",
                overview: "",
                genreIDs: [],
                releaseDate: .now,
                posterPath: URL(string: "https://image.tmdb.org/t/p/w500/qmDpIHrmpJINaRKAfWQfftjCdyi.jpg")
            ),
            MovieListItem(
                id: 2,
                title: "La La Land",
                originalTitle: "La La Land",
                originalLanguage: "en",
                overview: "",
                genreIDs: [],
                releaseDate: .now,
                posterPath: URL(string: "https://image.tmdb.org/t/p/w500/uDO8zWDhfWwoFdKS4fzkUJt0Rf0.jpg")
            ),
            MovieListItem(
                id: 3,
                title: "Interstellar",
                originalTitle: "Interstellar",
                originalLanguage: "en",
                overview: "",
                genreIDs: [],
                releaseDate: .now,
                posterPath: URL(string: "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg")
            )
        ]
    )
}
