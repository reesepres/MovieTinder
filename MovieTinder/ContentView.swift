//
//  ContentView.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/1/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let navy = Color(red: 15/225, green: 34/255, blue: 116/225)
        NavigationStack {
            ZStack {
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Text("Movie Tinder")
                        .font(.system(size: 60, design: .serif))
                        .padding(.top, 60)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    
                    NavigationLink(destination: NumberPeople()) {
                        Text("Pick a Movie")
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .padding()
                            .frame(width: 250, height: 100)
                            .background(navy)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal,40)
                    }
                    .padding(.bottom, 120)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
