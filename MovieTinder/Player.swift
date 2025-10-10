import SwiftUI

struct Player: Identifiable {
    let id: Int
    let color: Color
}

func makePlayers(count: Int) -> [Player] {
    let colors: [Color] = [.red, .blue, .green, .orange, .purple]
    return (0..<count).map { i in
        Player(id: i, color: colors[i % colors.count])
    }
}
