//
//  Untitled.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/6/25.
//
import SwiftUI

struct NumberPeople: View {
    var body: some View {
        ZStack {
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
           
            VStack {
                Text("How many people")
                    .font(.system(size: 48, design: .serif))
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("are watching?")
                    .font(.system(size: 48, design: .serif))
                    .padding(.top, 0)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                    .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    NumberPeople()
}

