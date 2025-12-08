import SwiftUI
import TMDb
import AVKit

struct ContentView: View {
    
    @StateObject private var clientManager = TmdbApi()
    @State private var showFilters: Bool = false
    @State private var filter: MovieFilter = MovieFilter()
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
        NavigationStack(path: $navigationPath) {
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
                    
                    Button {
                        navigationPath.append("numberPeople")
                    } label: {
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
                .navigationDestination(for: String.self) { destination in
                    if destination == "numberPeople" {
                        NumberPeople { count in
                            navigationPath.append(count)
                        }
                    }
                }
                .navigationDestination(for: Int.self) { count in
                    LoadingScreen(
                        playerCount: count,
                        filter: filter,
                        clientManager: clientManager
                    )
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
    ContentView()
}
