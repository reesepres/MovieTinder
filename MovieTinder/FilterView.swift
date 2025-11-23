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
            .padding(.top)

            VStack {
                Text("Maximum Rating")
                Slider(value: $filter.maxRating, in: 0...10, step: 0.5)
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
                            Text("\(year)").tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)
                }

                Text("to")

                VStack {
                    Picker("End Year", selection: $filter.endYear) {
                        ForEach((filter.startYear...2025), id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)
                }
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
