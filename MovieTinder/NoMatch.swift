//
//  NoMatch.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/22/25.
//

import SwiftUI

struct NoMatch: View {
    let onRestart: () -> Void
    let onExit: () -> Void
    
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
                Button("Restart!", action: onRestart)
                    .font(.headline)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(navy)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                
                Button("Exit", action: onExit)
                    .font(.headline)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(navy)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                
                Spacer()
            }
        }
    }
}

#Preview {
    NoMatch(onRestart: {}, onExit: {})
}
