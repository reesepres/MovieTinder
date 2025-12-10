import SwiftUI
import TMDb

struct DetailedPosterCard: View {
    let movie: MovieListItem
    private let navy = Color(red: 10/225, green: 20/255, blue: 60/225)

    // in case TMDb sometimes puts text elsewhere
    private var displayTitle: String {
        movie.title
    }

    var body: some View {
        VStack(spacing: 12) {

            // MARK: - Poster
            PosterCard(movie: movie)

            // MARK: - Title
            Text(displayTitle)
                .frame(width: 300 , alignment: .leading)
                .font(.custom("ArialRoundedMTBold", size: 26))
                .foregroundColor(navy)
                .multilineTextAlignment(.leading)

            // MARK: - Stars
            starRow
                .frame(width: 300, alignment: .leading)


            // MARK: - Overview
            Text(movie.overview)
                .frame(width: 300)
                .font(.custom("ArialRoundedMTBold", size: 15))
                .foregroundColor(navy)
                .multilineTextAlignment(.leading)
                
        }
        .padding()
    }
}

// MARK: - Helpers
extension DetailedPosterCard {
    private var posterURL: URL? {
        if let path = movie.posterPath?.absoluteString {
            return URL(string: "https://image.tmdb.org/t/p/w500/\(path)")
        }
        return nil
    }

    private var starRow: some View {
        let avg = movie.voteAverage ?? 0
        let filled = Int(round(avg)) / 2
        let half = Int(round(avg)) % 2 != 0
        let empty = 5 - filled - (half ? 1 : 0)

        return HStack(spacing: 4) {
            ForEach(0..<filled, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.title3)
                    .foregroundColor(navy)
            }

            if half {
                Image(systemName: "star.leadinghalf.filled")
                    .font(.title3)
                    .foregroundColor(navy)
            }

            ForEach(0..<empty, id: \.self) { _ in
                Image(systemName: "star")
                    .font(.title3)
                    .foregroundColor(navy)
            }
        }
    }
}
