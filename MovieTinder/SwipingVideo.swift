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

// SwiftUI wrapper
private struct PlayerContainerView: UIViewRepresentable {
    func makeUIView(context: Context) -> PlayerUIView {
        PlayerUIView()
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        // nothing to update for now
    }
}

// Plain UIKit view that owns the AVPlayerLayer
private final class PlayerUIView: UIView {

    private let playerLayer = AVPlayerLayer()
    private var queuePlayer: AVQueuePlayer?
    private var looper: AVPlayerLooper?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black

        // Load video from bundle
        if let url = Bundle.main.url(forResource: "SwipingVideo", withExtension: "mov") {
            let item = AVPlayerItem(url: url)

            // AVQueuePlayer + AVPlayerLooper = smooth looping
            let queuePlayer = AVQueuePlayer(playerItem: item)
            let looper = AVPlayerLooper(player: queuePlayer, templateItem: item)

            self.queuePlayer = queuePlayer
            self.looper = looper

            queuePlayer.isMuted = true
            queuePlayer.play()

            playerLayer.player = queuePlayer
            playerLayer.videoGravity = .resize // or .resizeAspectFit / .resizeAspectFill
            layer.addSublayer(playerLayer)
        } else {
            // Visible fallback if the file isn't found
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
        // Make the video fill whatever SwiftUI frame we give it
        playerLayer.frame = bounds
    }
}
