import SwiftUI
import TMDb

private enum Stage: Equatable {
    case ready(playerIndex: Int)
    case swipe(playerIndex: Int, slide: Int)
    case done
}

private enum Outcome: Equatable {
    case none //NoMatch
    case single(MovieListItem) //Match
    case multiple([MovieListItem])//Matches
}

private struct ResultsView: View {
    let outcome: Outcome
    let onRestart: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        switch outcome {
        case .none:
            NoMatch(onRestart: onRestart, onExit: onExit)
        case .single(let movie):
            Match(movie: movie, onExit: onExit)
        case .multiple(let movies):
            Matches(movies: movies, onRestart: onRestart, onExit: onExit)
        }
    }
}


struct GameFlowView: View {
    let players: [Player]
    let movies: [MovieListItem]
    private let totalSlides = 10

    @State private var stage: Stage = .ready(playerIndex: 0)
    @State private var currentMovieIndex = 0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        switch stage {
        case .ready(let i):
            FillerReadyScreen(player: players[i]) {
                stage = .swipe(playerIndex: i, slide: 0)
            }

        case .swipe(let i, let slide):
            YesNoScreen(
                backgroundColor: players[i].color,
                index: slide,
                total: totalSlides,
                movie: movies.indices.contains(currentMovieIndex) ? movies[currentMovieIndex] : nil
            ) {
                let nextSlide = slide + 1
                currentMovieIndex = (currentMovieIndex+1) % totalSlides
                if nextSlide < totalSlides {
                    stage = .swipe(playerIndex: i, slide: nextSlide)
                } else {
                    let nextPlayer = i + 1
                    stage = (nextPlayer < players.count)
                        ? .ready(playerIndex: nextPlayer)
                        : .done
                }
            }

        case .done:
                   ResultsView(
                       outcome: placeholderOutcome(players: players, movies: movies),
                       onRestart: {
                           currentMovieIndex = 0
                           stage = .ready(playerIndex: 0)
                       },
                       onExit: {
                           dismiss()
                       }
                   )
               }
           }
    //ALGORITHM GOES IN HERE!!!!!
    private func placeholderOutcome(players: [Player], movies: [MovieListItem]) -> Outcome {
            guard !movies.isEmpty else { return .none }
            switch players.count % 3 {
            case 0: return .none
            case 1: return .single(movies[0])
            default: return .multiple(Array(movies.prefix(min(5, movies.count))))
            }
        }
}

private struct FillerReadyScreen: View {
    let player: Player
    var onStart: () -> Void

    var body: some View {
        ZStack {
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("Movie Tinder")
                    .font(.system(size: 60, design: .serif))
                    .padding(.top, 60)

                Spacer()

                Button(action: onStart) {
                    Text("I'm Ready to\nPick!")
                        .font(.system(size: 35))
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 250, height: 150)
                        .background(player.color)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.6), radius: 12, x: 0, y: 6)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

#Preview {
    let mockMovies: [MovieListItem] = [
        MovieListItem(
            id: 1,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A ticking-time-bomb insomniac...",
            genreIDs: [18],
            releaseDate: Date(timeIntervalSince1970: 937392000),
            posterPath: nil
        ),
        MovieListItem(
            id: 2,
            title: "Inception",
            originalTitle: "Inception",
            originalLanguage: "en",
            overview: "A thief who steals corporate secrets...",
            genreIDs: [28, 878],
            releaseDate: Date(timeIntervalSince1970: 1279257600),
            posterPath: nil
            
        )
    ]
    GameFlowView(players: makePlayers(count: 2), movies: mockMovies)
}

