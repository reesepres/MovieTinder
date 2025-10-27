import SwiftUI
import TMDb

struct YesNoScreen: View {
    let backgroundColor: Color
    let index: Int
    let total: Int
    let movie: MovieListItem?
    var onTap: () -> Void

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        Color.clear
                            .frame(height: 0)
                            .id("top")

                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie?.posterPath?.absoluteString ?? "")")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 500)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                                    .padding(.horizontal)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 500)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }

                        Text(movie?.title ?? "No movie available")
                            .font(.system(size: 32, weight: .semibold, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 8)

                        HStack(spacing: 4) {
                            ForEach(0..<Int(movie?.voteAverage ?? 0) / 2, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.title3)
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                        Text(movie?.overview ?? "PG\nDescription:\nThis is where our description will go for each movie! ------------------------------------------------------------------------------")
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)

                        HStack(spacing: 90) {
                            Button("No") { onTap() }
                                .font(.title3.bold())
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
                        .padding(.top, 16)
                        .padding(.bottom, 60)
                    }
                    .foregroundColor(.black)
                    .padding(.top)
                }
                .onChange(of: index) { _ in
                    withAnimation(.easeInOut) {
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
            }
        }
    }
}

#Preview {
    let mockMovies: [MovieListItem] = [
        MovieListItem(
            id: 1,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A ticking-time-bomb insomniac and a soap salesman channel primal male aggression into a shocking new form of therapy.",
            genreIDs: [18],
            releaseDate: Date(timeIntervalSince1970: 937392000),
            posterPath: nil
        )
    ]
    YesNoScreen(backgroundColor: .mint, index: 0, total: 10, movie: mockMovies.first) { }
}
