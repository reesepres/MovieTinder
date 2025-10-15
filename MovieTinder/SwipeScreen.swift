//
//  SwipeScreen.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/11/25.
//

import SwiftUI

struct YesNoScreen: View {
    let backgroundColor: Color
    let index: Int
    let total: Int
    var onTap: () -> Void

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 24) {
                
                Text("Movie Title")
                    .font(.system(size: 60, design: .serif))
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width:260, height: 300)
                
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self){ _ in
                        Image(systemName: "star.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("PG\nDescription:\nThis is where our description will go for each movie! ------------------------------------------------------------------------------")
                    .font(.headline)



                HStack(spacing: 90) {
                    
                    Button("No") { onTap() }
                        .font(.title3).bold()
                        .frame(width: 110, height: 80)
                        .background(Color.red)
                        .border(.black, width: 3.5)
                        .cornerRadius(10)

                    Button("Yes") { onTap() }
                        .font(.title3.bold())
                        .frame(width: 110, height: 80)
                        .background(Color.green)
                        .border(.black, width: 3.5)
                        .cornerRadius(10)
                }
            }
            .foregroundColor(.black)
            .padding()
        }
    }
}

#Preview {
    YesNoScreen(backgroundColor: .mint, index: 0, total: 10) { }
}
