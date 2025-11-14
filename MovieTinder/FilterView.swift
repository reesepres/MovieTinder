//
//  FilterView.swift
//  MovieTinder
//
//  Created by Owen Blanchard on 11/13/25.
//

import SwiftUI

struct MovieFilter: Equatable {
    var minRating: Double = 0
    var maxRating: Double = 10
    var startYear: Int = 1900
    var endYear: Int = 2100
    var language: String = ""
}

struct FilterView: View{
    @Binding var filter: MovieFilter
    var onDone: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Filters")
                .font(.title)
                .padding(.top)
            
            VStack {
                Text("Minimum Rating")
                Slider(value: $filter.minRating, in: 0...10, step: 0.5)
                Text("\(filter.minRating, specifier: "%.1f")")
            }
            
            VStack {
                Text("Maximum Rating")
                Slider(value: $filter.maxRating, in: 0...10, step: 0.5)
                Text("\(filter.maxRating, specifier: "%.1f")")
            }
            
            VStack {
                Text("Start Year")
                Stepper(value: $filter.startYear, in: 1900...2100) {
                    Text("\(filter.startYear)")
                }
            }
            
            VStack {
                Text("End Year")
                Stepper(value: $filter.endYear, in: 1900...2100) {
                    Text("\(filter.endYear)")
                }
            }
            
            VStack {
                Text("Language (e.g. en)")
                TextField("Language", text: $filter.language)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 150)
            }
            
            Button("Done") {
                onDone()
            }
            .font(.title2)
            .padding()
        }
        .padding()
    }
}
