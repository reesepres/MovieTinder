import SwiftUI
import TMDb

struct YesNoScreen: View {
    let backgroundColor: Color
    let index: Int
    let total: Int
    let movie: MovieListItem?
    var onVote: (Bool) -> Void

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
                                    .frame(height: 400)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 300)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                                    .padding(.horizontal)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)
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
                            ForEach(0..<Int(round(movie?.voteAverage ?? 0)) / 2, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.title3)
                                    .foregroundColor(.black)
                            }
                            if(Int(round(movie?.voteAverage ?? 0)) % 2 != 0){
                                Image(systemName: "star.leadinghalf.filled")
                                    .font(.title3)
                                    .foregroundColor(.black)
                                ForEach(0..<(4-Int(round((movie?.voteAverage ?? 0)))/2), id: \.self){ _ in
                                    Image(systemName: "star")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                }
                            } else {
                                ForEach(0..<(5-Int(round((movie?.voteAverage ?? 0)))/2), id: \.self){ _ in
                                    Image(systemName: "star")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                        Text(movie?.overview ?? "PG\nDescription:\nThis is where our description will go for each movie! ------------------------------------------------------------------------------")
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)

                        HStack(spacing: 90) {
                            Button("No") { onVote(false) }
                                .font(.title3.bold())
                                .frame(width: 110, height: 80)
                                .background(Color.red)
                                .border(.black, width: 3.5)
                                .cornerRadius(10)

                            Button("Yes") { onVote(true) }
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
                .onChange(of: index, initial: false) { _, _ in
                    withAnimation(.easeInOut) {
//                        proxy.scrollTo("top", anchor: .top)
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
            overview: "A ticking-time-bomb insomniac and a soap salesman channel primal male aggression into a shocking new form of therapy. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis quis lorem et diam lobortis molestie. Suspendisse condimentum mauris at ultricies placerat. Maecenas maximus elit et augue condimentum aliquam. Suspendisse potenti. Fusce nec purus quis turpis consectetur bibendum a non ligula. Fusce faucibus aliquam aliquet. In rutrum nisl orci, eu fringilla elit mattis at. Fusce maximus fringilla nibh, nec viverra ipsum consectetur eget. Sed ac diam sit amet eros mattis rutrum eget at odio. Ut quam nulla, rutrum at ullamcorper a, sollicitudin eget elit. Praesent mollis tincidunt quam. Nam sagittis, eros ac iaculis tincidunt, odio massa scelerisque lectus, ut imperdiet ante lectus non turpis. Mauris laoreet augue quis dolor iaculis fringilla. Aliquam id tellus pulvinar, rutrum nibh eu, imperdiet purus. Vivamus eu arcu viverra, sagittis sem sed, aliquam quam. Quisque nec viverra arcu, in luctus felis.",
            genreIDs: [18],
            releaseDate: Date(timeIntervalSince1970: 937392000),
            posterPath: nil,
            voteAverage: 4.6
        )
    ]
    YesNoScreen(backgroundColor: .mint, index: 0, total: 10, movie: mockMovies.first) {_ in }
}
