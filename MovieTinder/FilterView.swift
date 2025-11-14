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

private let acceptedLanguageCodes: Set<String> = [
    "en", "es", "fr", "de", "it", "pt", "ru", "ja", "ko", "zh",
    "hi", "ar", "nl", "sv", "no", "da", "fi", "pl", "tr",
    "he", "cs", "el", "hu", "th", "id", "ms", "ro", "sk",
    "uk", "vi", "bg", "hr", "sr", "sl"
]

struct FilterView: View{
    @Binding var filter: MovieFilter
    var onDone: () -> Void
    @State private var showLanguageAlert: Bool = false
    
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
                Text("Language (e.g. en, fr, es)")
                TextField("Any Language OK", text: $filter.language)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 150)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }
            
            Button("Done") {
                            let trimmed = filter.language
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .lowercased()

                            if trimmed.isEmpty {
                                filter.language = ""
                                onDone()
                            } else {
                                let isValidShape = trimmed.count == 2 && trimmed.allSatisfy { $0.isLetter }
                                let isValidCode = isValidShape && acceptedLanguageCodes.contains(trimmed)
                                if isValidCode {
                                    filter.language = trimmed
                                    onDone()
                                } else {
                                    showLanguageAlert = true
                                }
                            }
                        }
                        .font(.title2)
                        .padding()
        }
        .padding()
        .alert("Invalid language code", isPresented: $showLanguageAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You must enter a two-letter code like en, fr, es.")
        }
    }
}
