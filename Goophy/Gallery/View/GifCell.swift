//
//  GifCell.swift
//  Goophy
//
//  Created by Vadim Shalugin on 28.03.2022.
//

import AVFoundation
import UIKit

final class GifCell: UICollectionViewCell {
    
    private var videoPlayer: AVPlayer? = nil
  
    private lazy var playerView: PlayerView = {
        var player = PlayerView()
        player.backgroundColor = .random
        return player
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        playerView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        playerView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
  
    func play(url: URL) {

        videoPlayer = AVPlayer(url: url)
        videoPlayer?.playImmediately(atRate: 1)
        playerView.player = videoPlayer
        playerView.playerLayer.videoGravity = .resizeAspectFill

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.playerView.player?.currentItem, queue: .main) { [weak self] _ in
            self?.playerView.player?.seek(to: CMTime.zero)
            self?.playerView.player?.play()
        }
    }
}
