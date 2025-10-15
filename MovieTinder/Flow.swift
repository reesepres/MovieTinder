//
//  Flow.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/11/25.
//

import SwiftUI

private enum Stage: Equatable {
    case ready(playerIndex: Int)
    case swipe(playerIndex: Int, slide: Int)
    case done
}

struct GameFlowView: View {
    let players: [Player]
    private let totalSlides = 10

    @State private var stage: Stage = .ready(playerIndex: 0)

    var body: some View {
        switch stage {
        case .ready(let i):
            FillerReadyScreen(player: players[i]) {
                stage = .swipe(playerIndex: i, slide: 0)
            }

        case .swipe(let i, let slide):
            YesNoScreen (backgroundColor: players[i].color, index: slide, total: totalSlides) {
                let nextSlide = slide + 1
                if nextSlide < totalSlides {
                    stage = .swipe(playerIndex: i, slide: nextSlide)
                } else {
                    let nextPlayer = i + 1
                    stage = (nextPlayer < players.count)
                        ? .ready(playerIndex: nextPlayer)
                        : .done
                }
            }

        case .done:
            ZStack {
                Color.white.ignoresSafeArea()
                Text("All players done")
                    .font(.title.bold())
            }
        }
    }
}
private struct FillerReadyScreen: View {
    let player: Player
    var onStart: () -> Void

    var body: some View {
        ZStack {
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("Movie Tinder")
                    .font(.system(size: 60, design: .serif))
                    .padding(.top, 60)

                Spacer()

                Button(action: onStart) {
                    Text("I'm Ready to\nPick!")
                        .font(.system(size: 35))
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 250, height: 150)
                        .background(player.color)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.6), radius: 12, x: 0, y: 6)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

#Preview {
    GameFlowView(players: makePlayers(count: 2))
}
