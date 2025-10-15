//
//  AlgorithmTest.swift
//  MovieTinder
//
//  Created by Huthaifa Mohammad on 10/10/25.
//

class MovieVotingManager {
    
    var movies: [String]
    var votes: [String: [Bool]] // userID → yes/no for each movie
    
    init(movies: [String]) {
        
        self.movies = movies
        self.votes = [:]
    }

    func submitVotes(userID: String, responses: [Bool]) {
        votes[userID] = responses
    }

    func calculateResults() -> [String] {
        guard !votes.isEmpty else { return [] }
        var scores = Array(repeating: 0, count: movies.count)
        for responses in votes.values {
            for (i, choice) in responses.enumerated() where choice {
                scores[i] += 1
            }
        }
        let maxScore = scores.max() ?? 0
        return movies.enumerated().filter { scores[$0.offset] == maxScore }.map { $0.element }
    }
}
