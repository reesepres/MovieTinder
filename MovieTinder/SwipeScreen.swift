import SwiftUI
import TMDb

struct YesNoScreen: View {
    let backgroundColor: Color
    let index: Int
    let total: Int
    let movie: MovieListItem?
    var onVote: (Bool) -> Void

    @State private var dragOffset: CGSize = .zero   // for swipe

    var body: some View {
        let navy = Color(red: 10/225, green: 20/255, blue: 60/225)

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
                            .font(.custom("ArialRoundedMTBold", size: 40))
                            .foregroundColor(navy)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 8)

                        HStack(spacing: 4) {
                            ForEach(0..<Int(round(movie?.voteAverage ?? 0)) / 2, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.title3)
                                    .foregroundColor(navy)
                            }
                            if (Int(round(movie?.voteAverage ?? 0)) % 2 != 0) {
                                Image(systemName: "star.leadinghalf.filled")
                                    .font(.title3)
                                    .foregroundColor(navy)
                                ForEach(0..<(4 - Int(round((movie?.voteAverage ?? 0))) / 2), id: \.self) { _ in
                                    Image(systemName: "star")
                                        .font(.title3)
                                        .foregroundColor(navy)
                                }
                            } else {
                                ForEach(0..<(5 - Int(round((movie?.voteAverage ?? 0))) / 2), id: \.self) { _ in
                                    Image(systemName: "star")
                                        .font(.title3)
                                        .foregroundColor(navy)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                        Text(movie?.overview ?? "PG\nDescription:\nThis is where our description will go for each movie! ------------------------------------------------------------------------------")
                            .font(.custom("ArialRoundedMTBold", size: 15))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                    }
                    .foregroundColor(navy)
                    .padding(.top)
                }
                .onChange(of: index, initial: false) { _, _ in
                    withAnimation(.easeInOut) {
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
            }
        }
        
        
        .offset(x: dragOffset.width * 0.3)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if abs(value.translation.width) > abs(value.translation.height) {
                        dragOffset = value.translation
                    }
                }
                .onEnded { value in
                    let translation = value.translation
                    let threshold: CGFloat = 60

                    if abs(translation.width) > abs(translation.height),
                       abs(translation.width) > threshold {

                        if translation.width > 0 {
                            onVote(true)
                        } else {
                            onVote(false)
                        }
                    }

                    // if it thinks its not a swipe it "springs" back
                    withAnimation(.spring()) {
                        dragOffset = .zero
                    }
                }
        )
    }
}
