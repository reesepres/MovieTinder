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
    let onPosterTapped: (MovieListItem) -> Void

    @State private var currentIndex: Int = 0
    @State private var autoScroll = true

    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var lastDragValue: CGFloat = 0

    // Scrolls every 3 seconds
    private let timer = Timer.publish(
        every: 3,
        on: .main,
        in: .common
    ).autoconnect()

    // Loops the list
    private var loopedMovies: [MovieListItem] {
        guard !movies.isEmpty else { return [] }
        return movies + movies + movies
    }

    // Start of the middle set
    private var middleStart: Int {
        movies.count
    }

    var body: some View {
        ZStack {
            if !loopedMovies.isEmpty {

                GeometryReader { wholeAnimation in
                    let cardWidth: CGFloat = 260
                    let spacing: CGFloat = 10
                    let step = cardWidth + spacing

                    HStack(spacing: spacing) {
                        ForEach(loopedMovies.indices, id: \.self) { index in
                            PosterCard(movie: loopedMovies[index])
                                .frame(width: cardWidth, height: 360)
                                .onTapGesture {
                                    autoScroll = false
                                    onPosterTapped(loopedMovies[index])
                                }
                        }
                    }
                    .offset(
                        x: (wholeAnimation.size.width - cardWidth) / 2
                            - CGFloat(currentIndex) * step
                            + dragOffset    
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                autoScroll = false
                                isDragging = true
                                dragOffset = value.translation.width
                                lastDragValue = value.translation.width
                            }
                            .onEnded { value in
                                isDragging = false

                                let threshold: CGFloat = 80
                                let translation = value.translation.width

                                withAnimation(.easeInOut(duration: 0.25)) {

                                    if translation < -threshold {
                                        currentIndex += 1       // animate to next
                                    } else if translation > threshold {
                                        currentIndex -= 1       // animate to previous
                                    }

                                    dragOffset = 0              // animate back to center
                                }

                                lastDragValue = 0
                            }
                    )
                }
            }
        }
        .frame(width: 300, height: 380)
        .padding(.vertical, 10)

        .onAppear {
            if !movies.isEmpty {
                // Start at the beginning of the MIDDLE set
                currentIndex = middleStart
            }
        }

        .onReceive(timer) { _ in
            guard movies.count > 1, autoScroll else { return }
            goToNext()
        }

        .onChange(of: currentIndex) { _, _ in
            normalizeIndexIfNeeded()
        }
    }

    // Keeps the index in the middle (second) set
    // For n = 3:
    //   allowed indices: 3, 4, 5
    //   if we go to 6, 7, 8 → wrap back to 3, 4, 5
    private func normalizeIndexIfNeeded() {
        guard !movies.isEmpty else { return }

        let n = movies.count
        let allowedStart = n          // start of middle set
        let allowedEnd = 2 * n - 1    // end of middle set

        if currentIndex < allowedStart || currentIndex > allowedEnd {
            // Map currentIndex back into [allowedStart, allowedEnd]
            let logical = (currentIndex - allowedStart) % n
            let normalizedLogical = (logical + n) % n   // safe modulo for negatives
            currentIndex = allowedStart + normalizedLogical
        }
    }

    private func goToNext() {
        withAnimation(.easeInOut(duration: 0.35)) {
            currentIndex += 1
        }
    }

    private func goToPrevious() {
        withAnimation(.easeInOut(duration: 0.35)) {
            currentIndex -= 1
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
        ],
        onPosterTapped: { movie in
            print("Tapped: \(movie.title)")
        }
    )
}
