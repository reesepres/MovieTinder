//
//  ReadyToPick.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/10/25.
//
import SwiftUI

struct ReadyToPick: View {
    let player: Player
    let playerNumber: Int
    let onStart: () -> Void   // called when they tap the button
    
    var body: some View {
        let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
        
        ZStack {
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
           
            VStack(spacing: 200) {
                Text("Player \(playerNumber)")
                    .font(.custom("ArialRoundedMTBold", size: 60))
                    .padding(.top, 60)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(navy)
                
                Button(action: {
                    onStart()
                }) {
                    Text("I'm ready to\npick!")
                        .font(.custom("ArialRoundedMTBold", size: 35))
                        .padding()
                        .frame(width: 250, height: 150)
                        .background(player.color)
                        .foregroundColor(navy)
                        .cornerRadius(12)
                        .shadow(color: navy.opacity(0.6), radius: 12, x: 0, y: 6)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

#Preview {
    let samplePlayers = makePlayers(count: 3)
    return ReadyToPick(player: samplePlayers[0], playerNumber: 1, onStart: {})
}
