import SwiftUI
import TMDb
import AVKit

struct Main: View {
    
    @State private var goToReady: Bool = false
    @State private var players: [Player]? = nil
    @StateObject private var clientManager = TmdbApi()
    @State private var movies: [MovieListItem] = []
    @State private var showFilters: Bool = false
    @State private var filter: MovieFilter = MovieFilter()
    
    var body: some View {
        let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
        NavigationStack {
            ZStack {
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.72)
                
                VStack(spacing: 10) {
                    Text("Movie Tinder")
                        .font(.custom("ArialRoundedMTBold", size: 50))
                        .padding(.top, 70)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(navy)
                    
                    SwipingVideo()
                        .frame(width: 300, height:500)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Spacer()
                    
                    NavigationLink{
                        NumberPeople { count in
                            self.players = makePlayers(count: count)
                            Task {
                                await clientManager.fetchDiscoveredMovies(filteredBy: filter)
                                self.goToReady = true
//                                self.movies = clientManager.getMoviesFromCache(count: 10)
                            }
                        }
                    }
                    label: {
                        Text("Pick a Movie")
                            .font(.custom("ArialRoundedMTBold", size: 30))
                            .padding()
                            .frame(width: 250, height: 80)
                            .background(navy)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            //.padding(.horizontal,40)
                    }
                    //.padding(.bottom, 10)
                    
                    Button {
                        showFilters = true
                    } label: {
                        Text("Filters")
                            .font(.custom("ArialRoundedMTBold", size: 26))
                            .padding()
                            .frame(width: 250, height: 80)
                            .background(navy.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 40)
                }
                .toolbar(.hidden, for: .navigationBar)
                .navigationDestination(isPresented: $goToReady){
                    LoadingScreen(playerCount: (players ?? []).count, filter: filter, clientManager: clientManager)
                }
                .sheet(isPresented: $showFilters){
                    FilterView(filter: $filter, onDone: {
                        showFilters = false
                    }, clientManager: clientManager)
                    .navigationBarHidden(true)
                }
            }
            .onAppear {
                // Start preloading movies when app opens
                clientManager.startPreloadingMovies(filter: filter)
            }
        }
    }
}

#Preview {
    Main()
}
