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

            VStack(spacing: 24) {
                
                Text(movie?.title ?? "No movie available")
                    .font(.system(size: 60, design: .serif))
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie?.posterPath?.absoluteString ?? "")")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView() // While loading
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 300)
                                        .cornerRadius(12)
                                        .shadow(radius: 5)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 300)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }

                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self){ _ in
                        Image(systemName: "star.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(movie?.overview ?? "PG\nDescription:\nThis is where our description will go for each movie! ------------------------------------------------------------------------------")
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
    let mockMovies: [MovieListItem] = [
        MovieListItem(
            id: 1,
            title: "Fight Club",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A ticking-time-bomb insomniac...",
            genreIDs: [18],
            releaseDate: Date(timeIntervalSince1970: 937392000),
            posterPath: nil
        )
    ]
    YesNoScreen(backgroundColor: .mint, index: 0, total: 10, movie: mockMovies.first) { }
}
