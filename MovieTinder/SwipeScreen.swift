//
//  YesNoScreen.swift
//

import SwiftUI
import TMDb

struct YesNoScreen: View {
    let backgroundColor: Color
    let index: Int
    let total: Int
    let movie: MovieListItem?
    var onVote: (Bool) -> Void

    @State private var dragOffset: CGSize = .zero   // for swipe
    
    private let navy = Color(red: 10/225, green: 20/255, blue: 60/225)

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Scroll reset anchor
                        Color.clear
                            .frame(height: 0)
                            .id("top")

                        // MARK: - Poster Widget
                        if let movie {
                            MoviePosterCard(movie: movie)
                        } else {
                            Text("No movie available")
                                .font(.custom("ArialRoundedMTBold", size: 30))
                                .foregroundColor(navy)
                        }
                    }
                    .padding(.top)
                }
                .onChange(of: index, initial: false) { _, _ in
                    withAnimation(.easeInOut) {
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
            }
        }

        // MARK: - Swipe Logic
        .offset(x: dragOffset.width * 0.3)
        .gesture(
            DragGesture()
                .onChanged { value in
                    // only horizontal drags
                    if abs(value.translation.width) > abs(value.translation.height) {
                        dragOffset = value.translation
                    }
                }
                .onEnded { value in
                    let translation = value.translation
                    let threshold: CGFloat = 30

                    // check swipe strength + direction
                    if abs(translation.width) > abs(translation.height),
                       abs(translation.width) > threshold {

                        if translation.width > 0 {
                            onVote(true)   // SWIPE RIGHT
                        } else {
                            onVote(false)  // SWIPE LEFT
                        }
                    }

                    withAnimation(.spring()) {
                        dragOffset = .zero
                    }
                }
        )
    }
}

#Preview {
    YesNoScreen(
        backgroundColor: .blue,
        index: 0,
        total: 3,
        movie: MovieListItem(
            id: 1,
            title: "Inception",
            originalTitle: "Inception",
            originalLanguage: "en",
            overview: "dream dream dream",
            genreIDs: [28],
            releaseDate: .now,
            posterPath: nil
        ),
        onVote: { _ in }
    )
}
