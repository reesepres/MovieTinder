import SwiftUI
import TMDb

struct YesNoScreen: View {
    let backgroundColor: Color
    let index: Int           // current movie index (for "X of Y" if you want)
    let total: Int           // total movies
    let movie: MovieListItem?
    var onVote: (Bool) -> Void   // true = right swipe, false = left swipe
    
    @State private var dragOffset: CGSize = .zero
    
    // tweak these to feel like the example
    private let swipeThreshold: CGFloat = 80       //how far you have to swipe
    private let rotationFactor: CGFloat = 25       //how much the card tilts
    private let flingDuration: Double = 0.4        //how long it takes to fling away
    
    private let navy = Color(red: 10/225, green: 20/255, blue: 60/225)
    let maroon = Color(red: 90/255, green: 0/255, blue: 30/255)
    
    var body: some View {
        ZStack {
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.65)
//            Color(hex: "F57C73")
//                .ignoresSafeArea()
//            Color(hex: "FAE588")
//                .ignoresSafeArea()
//                .opacity(0.7)
//                .opacity(0.7)
//            navy.opacity(0.4)
//                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Movie \(index + 1) of \(total)")
                    .font(.custom("ArialRoundedMTBold", size: 18))
                    .foregroundColor(navy.opacity(0.8))
                
                if let movie {
                    //This is the card you swipe
                    MoviePosterCard(movie: movie)
                        .frame(maxWidth: 300)
                        .padding()
                        .background(backgroundColor)
                        .cornerRadius(20)
                        .shadow(color: shadowColorForDrag(),
                                radius: 25,
                                x: 0,
                                y: 25)
                        .offset(x: dragOffset.width,
                                y: dragOffset.height * 0.1)
                        .rotationEffect(
                            .degrees(Double(dragOffset.width / rotationFactor))
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    //Horizontal Drags
                                    if abs(value.translation.width) > abs(value.translation.height) {
                                        dragOffset = value.translation
                                    }
                                }
                                .onEnded { value in
                                    let translation = value.translation
                                    let isHorizontal =
                                    abs(translation.width) > abs(translation.height)
                                    let passedThreshold =
                                    abs(translation.width) > swipeThreshold
                                    
                                    if isHorizontal && passedThreshold {
                                        let swipedRight = translation.width > 0
                                        let targetX: CGFloat = swipedRight ? 1000 : -1000
                                        
                                        //animate card flinging off-screen
                                        withAnimation(.easeOut(duration: flingDuration)) {
                                            dragOffset = CGSize(
                                                width: targetX,
                                                height: translation.height * 0.2
                                            )
                                        }
                                        
                                        //call onVote after the animation finishes
                                        DispatchQueue.main.asyncAfter(
                                            deadline: .now() + flingDuration
                                        ) {
                                            onVote(swipedRight)
                                            dragOffset = .zero
                                        }
                                    } else {
                                        //if the user doesn't swipe far enough then it goes back
                                        withAnimation(.spring()) {
                                            dragOffset = .zero
                                        }
                                    }
                                }
                        )
                } else {
                    Text("No movie available")
                        .font(.custom("ArialRoundedMTBold", size: 24))
                        .foregroundColor(navy)
                }
            }
            .padding()
        }
    }
    
    
    
    private func shadowColorForDrag() -> Color {
        if dragOffset.width > 0 {
//            return Color(hex: "00ff00").opacity(0.8)  //swiping right
//            return Color(hex: "033500").opacity(0.8)  //swiping right
            return Color.green.opacity(1.0)
        } else if dragOffset.width < 0 {
            //return maroon.opacity(0.8)     //swiping left
            return Color(hex: "FF2800").opacity(1.0)
        } else {
            return Color.clear    //no swipe
        }
    }
    private func highlightBorderColor() -> Color {
        if dragOffset.width > 0 {
//            return Color(hex: "00ff00").opacity(0.8)
            return Color(hex: "033500").opacity(1.0)  //swiping right
//            return Color.green.opacity(0.8)
        } else if dragOffset.width < 0 {
            //return maroon
            return Color(hex: "FF2800").opacity(1.0)
        } else {
            return Color.clear
        }
    }
}
