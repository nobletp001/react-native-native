// VideoPlayerView.swift
import AVFoundation
import UIKit

@objc class VideoPlayerView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    // Properties with @objc exposure
    @objc var uri: String = "" {
        didSet {
            setupPlayer()
        }
    }
    
    @objc var paused: Bool = false {
        didSet {
            if paused {
                player?.pause()
            } else {
                player?.play()
            }
        }
    }
    
    @objc var muted: Bool = false {
        didSet {
            player?.isMuted = muted
        }
    }
    
    @objc var volume: Float = 1.0 {
        didSet {
            player?.volume = volume
        }
    }
    
    private var videoGravity: AVLayerVideoGravity = .resizeAspect {
        didSet {
            playerLayer?.videoGravity = videoGravity
        }
    }
    
    @objc var resizeMode: String = "contain" {
        didSet {
            switch resizeMode {
            case "cover":
                videoGravity = .resizeAspectFill
            case "stretch":
                videoGravity = .resize
            default:
                videoGravity = .resizeAspect
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .black
        
        // Setup player layer
        playerLayer = AVPlayerLayer()
        playerLayer?.videoGravity = videoGravity
        
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }
    }
    
    private func setupPlayer() {
        guard let url = URL(string: uri) else { return }
        
        // Create new player
        let player = AVPlayer(url: url)
        self.player = player
        playerLayer?.player = player
        
        // Apply current settings
        player.isMuted = muted
        player.volume = volume
        
        if !paused {
            player.play()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}
