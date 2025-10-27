//
//  Match.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/22/25.
//
import SwiftUI

struct Match: View {
    
    var body: some View{
        ZStack{
            Image("MatchBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack{
                Text("MATCH!")
                    .font(.system(size: 60, design: .serif))
                    .padding(.top, 60)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width:300, height: 400)
                
                Spacer()
            }
        }
    }
}

#Preview {
    Match()
}

