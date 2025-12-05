//
//  SwipingVideo.swift
//  MovieTinder
//
//  Created by Reese Preston on 12/3/25.
//

import SwiftUI
import AVKit

struct SwipingVideo: View {
    var body: some View {
        PlayerContainerView()
    }
}

//SwiftUI wrapper we need this because this is a view but if we want clean looping we need to use a UIViewRepresentable. I tried to just use the UIView only but I was struggling and using the wrapper was how I got it to work for now. We should look into a simpler way of doing this!
private struct PlayerContainerView: UIViewRepresentable {
    func makeUIView(context: Context) -> PlayerUIView {
        PlayerUIView()
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        // nothing to update for now
    }
}

private final class PlayerUIView: UIView {

    private let playerLayer = AVPlayerLayer()
    private var queuePlayer: AVQueuePlayer?
    private var looper: AVPlayerLooper?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black //If it weren't to fill right this is the color that would show

        // Load video
        if let url = Bundle.main.url(forResource: "SwipingVideo", withExtension: "mov") {
            let item = AVPlayerItem(url: url)

            //Allows for looping
            let queuePlayer = AVQueuePlayer(playerItem: item)
            let looper = AVPlayerLooper(player: queuePlayer, templateItem: item)

            self.queuePlayer = queuePlayer
            self.looper = looper

            queuePlayer.isMuted = true
            queuePlayer.play()

            playerLayer.player = queuePlayer
            playerLayer.videoGravity = .resize //makes it fit (there are other options to do this if we think it looks bad)
            layer.addSublayer(playerLayer)
        } else {
            //If it can't find or load the video for some reason
            backgroundColor = .red
            let label = UILabel()
            label.text = "Video not found"
            label.textColor = .white
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: centerXAnchor),
                label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //This is also to make sure the video fills the frame we gave it in ContentView
        playerLayer.frame = bounds
    }
}
