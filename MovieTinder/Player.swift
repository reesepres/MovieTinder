import SwiftUI

private let pink = Color(red: 225/225, green: 192/255, blue: 203/225)

struct Player: Identifiable {
    let id: Int
    let color: Color
}

func makePlayers(count: Int) -> [Player] {
    let colors: [Color] = [.red, .blue, .green, .orange, .purple, .yellow, .teal, pink]
    return (0..<count).map { i in
        Player(id: i, color: colors[i % colors.count])
    }
}


