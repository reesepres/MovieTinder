import SwiftUI
import TMDb



private struct ResultsView: View {
    let outcome: GameFlowView.ViewModel.Outcome
    let onRestart: () -> Void
    let onExit: () -> Void
    
    var body: some View {
        switch outcome {
        case .none:
            NoMatch(onRestart: onRestart, onExit: onExit)
        case .single(let movie):
            MatchView(movie: movie, onExit: onExit)
        case .multiple(let movies):
            MatchesView(movies: movies, onRestart: onRestart, onExit: onExit)
        }
    }
}


struct GameFlowView: View {
    

    @State private var viewModel : ViewModel
    @Environment(\.dismiss) private var dismiss
    var onDone: () -> Void
    
    init(players: [PlayerModel], movies: [MovieListItem], onDone: @escaping () -> Void) {
        _viewModel = State(initialValue: ViewModel(players: players, movies: movies))
        self.onDone = onDone
    }


    var body: some View {
        switch viewModel.stage {
        case .ready(let playerIndex):
            LobbyView(player: viewModel.players[playerIndex], playerNumber: playerIndex + 1 ) {
                viewModel.start(for: playerIndex)
            }.navigationBarBackButtonHidden(true)
            
        case .swipe(let playerIndex, let movieIndex):
            SwipeView(
                backgroundColor: viewModel.players[playerIndex].color,
                index: movieIndex,
                total: viewModel.movies.count,
                movie: viewModel.movies.indices.contains(viewModel.currentMovieIndex) ? viewModel.movies[viewModel.currentMovieIndex] : nil,
                onVote: { liked in
                    if let movie = viewModel.movies.indices.contains(viewModel.currentMovieIndex)
                        ? viewModel.movies[viewModel.currentMovieIndex]
                        : nil
                    {
                        viewModel.recordVote(for: movie.id, liked: liked, playerIndex: playerIndex)
                    }
                    viewModel.advance(for: playerIndex, movieIndex: movieIndex)
                }
            )
            .navigationBarBackButtonHidden(true)

        case .done:
                   ResultsView(
                        outcome: viewModel.outcome,
                        onRestart: viewModel.restart,
                        onExit: {
                           onDone()
                           dismiss()
                       }
                   ).navigationBarBackButtonHidden(true)
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
    GameFlowView( players: makePlayers(count: 2), movies: mockMovies, onDone: {})
}
