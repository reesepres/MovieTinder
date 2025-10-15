import SwiftUI

struct MovieVotingView: View {
    var movies: [String]
    var player: Player
    var onFinish: ([Bool]) -> Void   // callback to ReadyToPick

    @State private var currentMovieIndex = 0
    @State private var userResponses: [Bool] = []

    var body: some View {
        VStack(spacing: 25) {
            Text("🎬 \(movies[currentMovieIndex])")
                .font(.title)
                .padding()

            Text("Player \(player.id + 1)")
                .font(.headline)
                .foregroundColor(player.color)

            HStack(spacing: 40) {
                Button("👎 No") { vote(false) }
                    .voteButton(color: .red)
                Button("👍 Yes") { vote(true) }
                    .voteButton(color: .green)
            }

            Text("Movie \(currentMovieIndex + 1) of \(movies.count)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .animation(.easeInOut, value: currentMovieIndex)
        .padding()
    }

    // MARK: - Voting logic
    func vote(_ liked: Bool) {
        userResponses.append(liked)
        if currentMovieIndex < movies.count - 1 {
            currentMovieIndex += 1
        } else {
            onFinish(userResponses)
        }
    }
}

// MARK: - Reusable button style
extension Button {
    func voteButton(color: Color) -> some View {
        self
            .padding()
            .frame(width: 120)
            .background(color.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

// MARK: - Preview
#Preview {
    MovieVotingView(
        movies: ["Inception", "La La Land", "Interstellar"],
        player: Player(id: 0, color: .red),
        onFinish: { _ in }
    )
}
