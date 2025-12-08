import SwiftUI
import TMDb
import AVKit

struct ContentView: View {
    
    @State private var goToReady: Bool = false
    @State private var players: [Player]? = nil
    @StateObject private var clientManager = TmdbApi()
    @State private var movies: [MovieListItem] = []
    @State private var showFilters: Bool = false
    @State private var filter: MovieFilter = MovieFilter()
    @State private var showLoading: Bool = false
    
    var body: some View {
        let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
        NavigationStack {
            ZStack {
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
                VStack(spacing: 10) {
                    Text("Movie Tinder")
                        .font(.custom("ArialRoundedMTBold", size: 50))
                        .padding(.top, 60)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(navy)
                    
                    SwipingVideo()
                        .frame(width: 300, height:500)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Spacer()
                    
                    NavigationLink{
                        NumberPeople { count in
                            self.players = makePlayers(count: count)
                            self.showLoading = true
                            
                            Task {
                                // Wait for minimum movies needed (count * 10)
                                await clientManager.waitForMinimumMovies(count: count * 10)
                                
                                // Get movies from cache
                                let cachedMovies = clientManager.getMoviesFromCache(count: count * 10)
                                
                                if cachedMovies.count >= count * 10 {
                                    self.movies = cachedMovies
                                } else {
                                    // Fallback: fetch fresh if cache doesn't have enough
                                    await clientManager.fetchDiscoveredMovies(filteredBy: filter)
                                    self.movies = clientManager.discoveredMovies
                                }
                                
                                self.showLoading = false
                                self.goToReady = true
                            }
                        }
                    }
                    label: {
                        Text("Pick a Movie")
                            .font(.custom("ArialRoundedMTBold", size: 30))
                            .padding()
                            .frame(width: 250, height: 100)
                            .background(navy)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
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
                    GameFlowView(players: players ?? [], movies: movies)
                }
                .sheet(isPresented: $showFilters){
                    FilterView(filter: $filter, onDone: {
                        showFilters = false
                    }, clientManager: clientManager)
                    .navigationBarHidden(true)
                }
                
                // Loading overlay
                if showLoading {
                    LoadingView()
                }
            }
            .onAppear {
                // Start preloading movies when app opens
                clientManager.startPreloadingMovies(filter: filter)
            }
        }
    }
}

struct LoadingView: View {
    let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                
                Text("Loading Movies...")
                    .font(.custom("ArialRoundedMTBold", size: 24))
                    .foregroundColor(.white)
                
                Text("Please wait while we prepare your movie selection")
                    .font(.custom("ArialRoundedMTBold", size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(40)
            .background(navy)
            .cornerRadius(20)
            .shadow(radius: 20)
        }
    }
}

#Preview {
    ContentView()
}
