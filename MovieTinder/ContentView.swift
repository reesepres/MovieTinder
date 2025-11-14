import SwiftUI
import TMDb

struct ContentView: View {
    
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
                
                VStack {
                    Text("Movie Tinder")
                        .font(.custom("ArialRoundedMTBold", size: 50))
                        .padding(.top, 60)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(navy)
                    Spacer()

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
                    .padding(.bottom, 20)
                    
                    NavigationLink{
                        NumberPeople { count in
                            self.players = makePlayers(count: count)
                            Task {
                                await clientManager.fetchDiscoveredMovies(filteredBy: filter)
                                self.movies = clientManager.discoveredMovies
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
                            .padding(.horizontal,40)
                    }
                    .padding(.bottom, 120)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $goToReady) {
                GameFlowView(players: players ?? [], movies: movies)
            }
            .sheet(isPresented: $showFilters) {
                FilterView(filter: $filter) {
                    showFilters = false
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
