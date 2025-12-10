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
    var endYear: Int = 2025
    var language: String = ""
}

private let languageOptions: [(name: String, code: String)] = [
    ("Any Language", ""),
    ("English", "en"),
    ("Español", "es"),
    ("Français", "fr"),
    ("Deutsch", "de"),
    ("Italiano", "it"),
    ("Português", "pt"),
    ("Русский", "ru"),
    ("日本語", "ja"),
    ("한국어", "ko"),
    ("中文", "zh"),
    ("हिन्दी", "hi"),
    ("العربية", "ar"),
    ("Nederlands", "nl"),
    ("Svenska", "sv"),
    ("Norsk", "no"),
    ("Dansk", "da"),
    ("Suomi", "fi"),
    ("Polski", "pl"),
    ("Türkçe", "tr"),
    ("Ελληνικά", "el"),
    ("Čeština", "cs"),
    ("Magyar", "hu"),
    ("ไทย", "th"),
    ("Bahasa Indonesia", "id"),
    ("Bahasa Melayu", "ms"),
    ("Română", "ro"),
    ("Slovenčina", "sk"),
    ("Українська", "uk"),
    ("Tiếng Việt", "vi"),
    ("Български", "bg"),
    ("Hrvatski", "hr"),
    ("Српски", "sr"),
    ("Slovenščina", "sl")
]

struct FilterView: View{
    @Binding var filter: MovieFilter
    var onDone: () -> Void
    @ObservedObject var clientManager: TmdbApi
    @State private var showLanguageAlert: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Filters")
                .font(.title)
                .padding(.top)

            VStack {
                Text("Minimum Rating")
                Slider(value: Binding(
                    get: { filter.minRating },
                    set: { newValue in
                        // Round to nearest 0.5
                        let stepped = (newValue * 2).rounded() / 2

                        // If stepping beyond max - 1, push max up
                        if stepped + 1 > filter.maxRating {
                            filter.maxRating = stepped + 1
                        }

                        filter.minRating = stepped
                    }
                ), in: 0...9.0, step: 0.5)
                Text("\(filter.minRating, specifier: "%.1f")")
            }

            VStack {
                Text("Maximum Rating")
                Slider(value: Binding(
                    get: { filter.maxRating },
                    set: { newValue in
                        let stepped = (newValue * 2).rounded() / 2

                        // If stepping below min + 1, push min down
                        if stepped - 1 < filter.minRating {
                            filter.minRating = stepped - 1
                        }

                        filter.maxRating = stepped
                    }
                ), in: 1...10.0, step: 0.5)
                Text("\(filter.maxRating, specifier: "%.1f")")
            }

            VStack {
                Text("Change Language:")

                let currentLanguageName =
                    languageOptions.first(where: { $0.code == filter.language })?.name
                    ?? "Any Language"

                Menu(currentLanguageName) {
                    ForEach(languageOptions.indices, id: \.self) { i in
                        Button(languageOptions[i].name) {
                            filter.language = languageOptions[i].code
                        }
                    }
                }
                .frame(height: 44)
            }

            HStack{
                VStack {
                    Picker("Start Year", selection: $filter.startYear) {
                        ForEach((1900...filter.endYear), id: \.self) { year in
                            let sYear = String(year)
                            Text(sYear).tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)
                }

                Text("to")

                VStack {
                    Picker("End Year", selection: $filter.endYear) {
                        ForEach((filter.startYear...2025), id: \.self) { year in
                            let sYear = String(year)
                            Text(sYear).tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)
                }
            }
            
            // Display available movie count
            HStack {
                if clientManager.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading movies...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if clientManager.availableMovieCount > 0 {
                    Image(systemName: "film")
                        .foregroundColor(.green)
                    Text("\(clientManager.availableMovieCount) movies available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.orange)
                    Text("Loading movie count...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)

            Button("Done") {
                onDone()
            }
            .font(.title2)
            .padding()
        }
        .padding()
        .onChange(of: filter) { oldValue, newValue in
            // Restart preloading when filter changes
            clientManager.startPreloadingMovies(filter: newValue)
        }
    }
}
