import SwiftUI

struct ReadyToPick: View {
    let players: [Player]
    let movies: [String]
    @State private var currentPlayerIndex = 0
    @State private var allVotes: [[Bool]] = []
    @State private var showVoting = false
    @State private var showResults = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if showResults {
                    resultsView
                } else if currentPlayerIndex < players.count {
                    readyView(for: players[currentPlayerIndex])
                } else {
                    allDoneView
                }
            }
            .navigationDestination(isPresented: $showVoting) {
                if currentPlayerIndex < players.count {
                    MovieVotingView(
                        movies: movies,
                        player: players[currentPlayerIndex],
                        onFinish: handlePlayerFinish
                    )
                }
            }
        }
    }

    // MARK: - Subviews
    private func readyView(for player: Player) -> some View {
        VStack(spacing: 25) {
            Text("🎮 Player \(player.id + 1), your turn!")
                .font(.largeTitle)
                .foregroundColor(player.color)

            Button("Start Voting") {
                showVoting = true
            }
            .font(.title2)
            .padding()
            .frame(maxWidth: 200)
            .background(player.color)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }

    private var allDoneView: some View {
        VStack(spacing: 20) {
            Text("✅ All players finished voting!")
                .font(.title)
                .bold()
            Button("View Results") {
                showResults = true
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var resultsView: some View {
        let scores = calculateScores()
        return VStack(spacing: 15) {
            Text("🏆 Final Results")
                .font(.largeTitle)
                .bold()
            ForEach(scores.sorted(by: { $0.value > $1.value }), id: \.key) { movie, score in
                Text("\(movie): \(score) ")
                    .font(.headline)
            }
            Button("Restart") {
                restart()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    // MARK: - Logic
    func handlePlayerFinish(_ responses: [Bool]) {
        allVotes.append(responses)
        currentPlayerIndex += 1
        showVoting = false
    }

    func calculateScores() -> [String: Int] {
        var scores: [String: Int] = [:]
        for votes in allVotes {
            for (i, liked) in votes.enumerated() where liked {
                scores[movies[i], default: 0] += 1
            }
        }
        return scores
    }

    func restart() {
        allVotes = []
        currentPlayerIndex = 0
        showResults = false
    }
}

#Preview {
    ReadyToPick(
        players: makePlayers(count: 3),
        movies: ["Inception", "La La Land", "Interstellar"]
    )
}
