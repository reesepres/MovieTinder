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
        let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
        ZStack{
            Image("NoMatchesBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                Text("NO MATCHES!")
                    .font(.custom("ArialRoundedMTBold", size: 50))
                    .foregroundColor(navy)
                    .padding(.top, 80)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                Spacer()
                
                Button("Restart", action: onRestart)
                    .font(.custom("ArialRoundedMTBold", size: 20))
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(navy)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                
                Button("Exit", action: onExit)
                    .font(.custom("ArialRoundedMTBold", size: 20))
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
