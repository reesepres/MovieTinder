//
//  Match.swift
//  MovieTinder
//
//  Created by Reese Preston on 10/22/25.
//

import SwiftUI
import TMDb

// MARK: - Single Match Screen
struct MatchView: View {
    let movie: MovieListItem?
    let onExit: () -> Void
    
    @State private var showingAlert: Bool = false
   

    var body: some View {
        let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
        ZStack {
            Image("MatchBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .foregroundColor(navy)

            VStack(spacing: 20) {
                Text("MATCH!")
                    .font(.custom("ArialRoundedMTBold", size: 60))
                    .padding(.top, 40)
                    .foregroundColor(navy)
                VStack(spacing: 24){
                    if let movie {
                        DetailedPosterCardView(movie: movie)
                    } else {
                        Text("No movie available")
                            .font(.custom("ArialRoundedMTBold", size: 30))
                            .foregroundColor(navy)
                    }
                }
                .padding(.top)
                .frame(maxWidth: UIScreen.main.bounds.width)

                Spacer()

                Button("All Done!"){
                    
                    showingAlert = true
                }
                    .matchButtonStyle()
                   .alert(isPresented: $showingAlert) {
                       Alert(
                           title: Text("Important Question"),
                           message: Text("Return to home screen? You'll lose current results!"),
                           primaryButton: .destructive(Text("All Done")) {
                               // Action for "Delete"
                               onExit()
                           },
                           secondaryButton: .cancel() {
                               // Action for "Cancel"
                               print("User cancelled.")
                           }
                       )
                   }
                Spacer(minLength: 40)
            }
            .padding()
        }
    }
}
