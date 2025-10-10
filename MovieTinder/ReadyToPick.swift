//
//  ReadyToPick.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/10/25.
//
import SwiftUI

struct ReadyToPick: View {
    let players: [Player]
    @State private var index = 0

    var body: some View {
        if index < players.count {
            let player = players[index]
            VStack(spacing: 20) {
                Text("Player \(player.id + 1)")
                    .font(.largeTitle)

                Button("Start") {
                    index += 1   // later this will go to your swipe screen
                }
                .font(.title)
                .padding()
                .frame(maxWidth: 200)
                .background(player.color)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        } else {
            Text("All players done!")
                .font(.title)
        }
    }
}

#Preview {
    ReadyToPick(players: makePlayers(count: 3))
}
