//
//  NoMatch.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/22/25.
//

import SwiftUI

struct NoMatch: View {
    let players: [Player]
    
    var body: some View{
        let navy = Color(red: 15/225, green: 34/255, blue: 116/225)
        ZStack{
            Image("NoMatchesBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                Text("NO MATCHES!")
                    .font(.system(size: 55, design: .serif))
                    .padding(.top, 60)
                    .frame(maxWidth: .infinity, alignment: .center)
                NavigationLink {
                    ReadyToPick(players: players)
                } label: {
                    Text("Restart")
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .padding()
                        .frame(width: 250, height: 100)
                        .background(Color(navy))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    NoMatch(players: makePlayers(count: 4))
}
