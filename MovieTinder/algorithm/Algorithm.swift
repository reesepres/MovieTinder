//
//  Algorithm.swift
//  MovieTinder
//
//  Created by Huthaifa Mohammad on 10/1/25.
//
import Foundation

struct Algorithm {
    let maxPeople = 8

    // Example movie list "Temp"
    var movies = [
        "Inception", "Interstellar", "The Dark Knight", "Parasite",
        "The Matrix", "Avengers: Endgame", "Whiplash", "The Godfather",
        "Pulp Fiction", "Forrest Gump"
    ]
    
    // this has to change from a readline to a input box in the UI
    // Function to read a line safely
    
    func readInput(prompt: String) -> String {
        print(prompt, terminator: " ")
        return readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
    }
    
    var numPeople : Int = 0
//    if numPeople > maxPeople { numPeople = maxPeople }

//    let currentpool = readLine() ?? "10"

//    var currentPool : [String] = []

//    let movienum : Int = Int(currentpool) ?? 10

//    if  movienum <= 10 {
//        currentPool = Array(movies[..<movienum])
//    }
//    else {
//        currentPool = movies
//    }
    func MovieChoosing(){
        while movies.count > 2 {
            var votes: [String: Int] = [:]
            for movie in movies {
                votes[movie] = 0
            }
            
            // Each person goes through the entire list
            for person in 1...numPeople {
                print("\nPerson \(person), please vote YES/NO for each movie:")
                
                for movie in movies {
                    let response = readInput(prompt: "Do you want to watch '\(movie)'? (yes/no):")
                    if response == "yes" || response == "y" {
                        votes[movie]! += 1
                    }
                }
            }
            
            // Find max yes count
            if let maxVotes = votes.values.max() {
                // Keep only top-voted movies
                var nextRound = votes.filter { $0.value == maxVotes }.map { $0.key }
//                movies = nextRound
                print("\nMovies moving to next round: \(movies)")
            }
        }
        
        print("\nFinal selection of movies: \(movies)")
    }

    
    

}
