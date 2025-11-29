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

    // Starts in the middle
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

                            MoviePosterOnlyCard(movie: loopedMovies[index])
                                .frame(width: cardWidth, height: 360)
//                                .scaleEffect(index == currentIndex ? 1.7 : 1)
//                                .opacity(index == currentIndex ? 1.0 : 0.6)
                                .onTapGesture {
                                    autoScroll = false
                                    onPosterTapped(loopedMovies[index])
                                }
                        }
                    }
                    .offset(
                        x: (wholeAnimation.size.width - cardWidth) / 2
                            - CGFloat(currentIndex + middleStart) * step
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
                                let translation = lastDragValue

                                if translation < -threshold {
                                    goToNext()
                                } else if translation > threshold {
                                    goToPrevious()
                                }

                                dragOffset = 0
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

    // Keeps the index in the loop
    private func normalizeIndexIfNeeded() {
        guard !movies.isEmpty else { return }

        let n = movies.count
        let middleEnd = 2 * n - 1

        if currentIndex < middleStart || currentIndex > middleEnd {
            let logical = (currentIndex % n + n) % n
            let newIndex = middleStart + logical
            currentIndex = newIndex
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
            print("Tapped: \(movie.title)")   // 👈 preview behavior
        }
    )
}
