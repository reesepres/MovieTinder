//
//  Untitled.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/6/25.
//
import SwiftUI

struct NumberPeople: View {
    var onSelect: (Int) -> Void = { _ in }
    var body: some View {
        let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
        ZStack {
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
           
            VStack {
                Text("How many people")
                    .font(.custom("ArialRoundedMTBold", size: 40))
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(navy)
                Text("are watching?")
                    .font(.custom("ArialRoundedMTBold", size: 40))
                    .padding(.top, 0)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(navy)
                Spacer()
                    .navigationBarHidden(true)
                
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(150), spacing: 20), count: 2), spacing: 20)
                {ForEach(1...8, id: \.self) { number in
                    Button(action: {
                        onSelect(number)
                    }) {
                        Text("\(number)")
                            .font(.system(size: 32, weight: .bold))
                            .frame(width: 130, height: 100)
                            .background(navy)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }}}
                .padding(.top, 0)
                Spacer()
            }
        }
    }
}

#Preview {
    NumberPeople()
}

