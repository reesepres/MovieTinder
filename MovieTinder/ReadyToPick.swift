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
        ZStack {
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
           
            if index < players.count {
                let player = players[index]
                
                VStack(spacing: 200) {
                    
                    Text("Movie Tinder")
                        .font(.system(size: 60, design: .serif))
                        .padding(.top, 60)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: {
                        index += 1
                    }){
                        Text("I'm Ready to\nPick!")
                    
                    .font(.system(size: 35, design: .default))
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
            } else {
                Text("All players done!")
                    .font(.title)
            }
            Spacer()
        }
        
    }
}

#Preview {
    ReadyToPick(players: makePlayers(count: 3))
}

