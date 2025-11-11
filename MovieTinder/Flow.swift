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
    @State var movies: [MovieListItem]
    private let totalSlides = 10
    
    @State private var votes: [Int: [Bool]] = [:]

    @State private var stage: Stage = .ready(playerIndex: 0)
    @State private var currentMovieIndex = 0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        switch stage {
        case .ready(let i):
            ReadyToPick(
                player: players[i],
                playerNumber: i + 1,
                onStart: {
                    stage = .swipe(playerIndex: i, slide: 0)
                }
                )
            .navigationBarBackButtonHidden(true)
        case .swipe(let i, let slide):
            YesNoScreen(
                backgroundColor: players[i].color,
                index: slide,
                total: movies.count,
                movie: movies.indices.contains(currentMovieIndex) ? movies[currentMovieIndex] : nil,
                onVote: { liked in
                    guard let movie = movies[safe: currentMovieIndex] else {return}
                    recordVote(for: movie.id, liked: liked, playerIndex: i)
                    let nextSlide = slide + 1
                    currentMovieIndex = (currentMovieIndex+1) % movies.count
                    if nextSlide < movies.count {
                        stage = .swipe(playerIndex: i, slide: nextSlide)
                    } else {
                        let nextPlayer = i + 1
                        stage = (nextPlayer < players.count)
                            ? .ready(playerIndex: nextPlayer)
                            : .done
                    }
                }
            ) .navigationBarBackButtonHidden(true)

        case .done:
            let outcome = computeOutcome()

                ResultsView(
                    outcome: outcome,
                    onRestart: {
                        if case .multiple(let tiedMovies) = outcome, !tiedMovies.isEmpty {
                            // Run-off only if we have movies to retry
                            movies = tiedMovies
                            votes.removeAll()
                            currentMovieIndex = 0
                            stage = .ready(playerIndex: 0)
                        } else {
                            // No movies left — go to NoMatch instead
                            stage = .done
                        }
                    },
                    onExit: {
                        dismiss()
                    }
                ).navigationBarBackButtonHidden(true)
               }
           }
    //ALGORITHM GOES IN HERE!!!!!
    private func recordVote(for movieID: Int, liked: Bool, playerIndex: Int){
        if votes[movieID] == nil {
            votes[movieID] = Array(repeating: false, count: players.count)
        }
        votes[movieID]?[playerIndex] = liked
    }
    private func placeholderOutcome(players: [Player], movies: [MovieListItem]) -> Outcome {
            guard !movies.isEmpty else { return .none }
            switch players.count % 3 {
            case 0: return .none
            case 1: return .single(movies[0])
            default: return .multiple(Array(movies.prefix(min(5, movies.count))))
            }
        }
    private func computeOutcome() -> Outcome {
        // count how many "true" votes each movie got
        let likeCountsByMovie: [Int: Int] = votes.mapValues { arr in
            arr.filter { $0 }.count
        }

        // find the highest like count
        let maxLikes = likeCountsByMovie.values.max()
        if(maxLikes ?? 0 < 1){
            return .none
        }
        // which movies hit that top score?
        let winners = movies.filter { movie in
            likeCountsByMovie[movie.id] == maxLikes
        }

        switch winners.count {
        case 0:
            return .none
        case 1:
            return .single(winners[0])
        default:
            return .multiple(winners)
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
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

