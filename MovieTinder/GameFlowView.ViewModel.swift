//
//  GameFlowView.ViewModel.swift
//  MovieTinder
//
//  Created by Bret Jackson on 11/3/25.
//

import Foundation
import TMDb

extension GameFlowView {
    @Observable @MainActor class ViewModel {
        enum Stage: Equatable {
            case ready(playerIndex: Int)
            case swipe(playerIndex: Int, movieIndex: Int)
            case done
        }

        enum Outcome: Equatable {
            case none //NoMatch
            case single(MovieListItem) //Match
            case multiple([MovieListItem])//Matches
        }
        
        var votes: [Int: [Bool]] = [:]
        let players: [Player]
        var movies: [MovieListItem]

        var stage: Stage = .ready(playerIndex: 0)
        var currentMovieIndex = 0
        var outcome: Outcome = .none
        
        init(players: [Player], movies: [MovieListItem]){
            self.players = players
            self.movies = movies
        }
        
        func start(for playerIndex: Int){
            stage = .swipe(playerIndex: playerIndex, movieIndex: 0)
        }
        
        func advance(for playerIndex: Int, movieIndex: Int){
            let nextMovieIndex = movieIndex + 1
            currentMovieIndex = (currentMovieIndex+1) % movies.count
            if nextMovieIndex < movies.count {
                stage = .swipe(playerIndex: playerIndex, movieIndex: nextMovieIndex)
            } else {
                let nextPlayer = playerIndex + 1
                stage = (nextPlayer < players.count)
                    ? .ready(playerIndex: nextPlayer)
                    : .done
                if nextPlayer >= players.count {
                    outcome = computeOutcome()
                }
            }
        }
        
        func restart() {
            currentMovieIndex = 0
            stage = .ready(playerIndex: 0)
            
            // If outcome is multiple -> run-off mode
            switch outcome {
            case .multiple(let tiedMovies):
                // Only keep tied movies
                print("RUN-OFF: limiting movies to tied movies:", tiedMovies.map{$0.title})
                
                // CLEAR votes
                votes = [:]
                
                // Replace movie list (THIS IS IMPORTANT)
                self.movies = tiedMovies

                // Reset outcome
                outcome = .none

            default:
                // Full restart normally
                votes = [:]
                outcome = .none
            }
        }

        
        func recordVote(for movieID: Int, liked: Bool, playerIndex: Int){
            if votes[movieID] == nil {
                votes[movieID] = Array(repeating: false, count: players.count)
            }
            votes[movieID]?[playerIndex] = liked
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
}
