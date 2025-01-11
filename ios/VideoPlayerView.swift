//
//  VideoPlayerView.swift
//  nativeTemplate
//
//  Created by machine on 1/11/25.
//

// VideoPlayerView.swift
import Foundation
import AVKit
import UIKit

class VideoPlayerView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var timeObserverToken: Any?
    private var statusObserver: NSKeyValueObservation?
    private var bufferObserver: NSKeyValueObservation?
    
    // Props
    var uri: String = "" {
        didSet {
            if uri != oldValue {
                setupPlayer()
            }
        }
    }
    
    var paused: Bool = false {
        didSet {
            if paused {
                player?.pause()
            } else {
                player?.play()
            }
        }
    }
    
    var muted: Bool = false {
        didSet {
            player?.isMuted = muted
        }
    }
    
    var volume: Float = 1.0 {
        didSet {
            player?.volume = volume
        }
    }
    
    var videoGravity: AVLayerVideoGravity = .resizeAspect {
        didSet {
            playerLayer?.videoGravity = videoGravity
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
        playerLayer = AVPlayerLayer()
        playerLayer?.videoGravity = videoGravity
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    private func setupPlayer() {
        guard let url = URL(string: uri) else { return }
        
        // Clean up existing player
        cleanup()
        
        // Create new player
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playerLayer?.player = player
        
        // Configure player
        player?.isMuted = muted
        player?.volume = volume
        if !paused {
            player?.play()
        }
        
        // Setup observers
        setupObservers()
    }
    
    private func setupObservers() {
        // Time observer
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.onProgress(time: time)
        }
        
        // Status observer
        statusObserver = player?.currentItem?.observe(\.status, options: [.new]) { [weak self] item, _ in
            switch item.status {
            case .readyToPlay:
                self?.onLoad()
            case .failed:
                if let error = item.error {
                    self?.onError(error: error)
                }
            default:
                break
            }
        }
        
        // Buffer observer
        bufferObserver = player?.currentItem?.observe(\.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] item, _ in
            self?.onBuffer(isBuffering: !item.isPlaybackLikelyToKeepUp)
        }
        
        // End observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
    }
    
    private func cleanup() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
        }
        statusObserver?.invalidate()
        bufferObserver?.invalidate()
        NotificationCenter.default.removeObserver(self)
        
        player?.pause()
        player = nil
    }
    
    // MARK: - Event handlers
    
    private func onLoad() {
        guard let duration = player?.currentItem?.duration else { return }
        sendEvent("onVideoLoad", ["duration": CMTimeGetSeconds(duration)])
    }
    
    private func onProgress(time: CMTime) {
        sendEvent("onVideoProgress", ["currentTime": CMTimeGetSeconds(time)])
    }
    
    private func onBuffer(isBuffering: Bool) {
        sendEvent("onVideoBuffer", ["isBuffering": isBuffering])
    }
    
    @objc private func playerItemDidReachEnd() {
        sendEvent("onVideoEnd", nil)
    }
    
    private func onError(error: Error) {
        sendEvent("onVideoError", ["message": error.localizedDescription])
    }
    
    private func sendEvent(_ name: String, _ body: [String: Any]?) {
        if let onEvent = onEvent {
            onEvent(name, body)
        }
    }
    
    // MARK: - Public interface
    
    var onEvent: ((_ name: String, _ body: [String: Any]?) -> Void)?
    
    deinit {
        cleanup()
    }
}

// MARK: - React Native View Manager
@objc(RCTVideoPlayerViewManager)
class VideoPlayerViewManager: RCTViewManager {
    override func view() -> UIView! {
        let view = VideoPlayerView()
        return view
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    // Constants for resize mode
    override func constantsToExport() -> [AnyHashable : Any]! {
        return [
            "RESIZE_MODE_CONTAIN": AVLayerVideoGravity.resizeAspect.rawValue,
            "RESIZE_MODE_COVER": AVLayerVideoGravity.resizeAspectFill.rawValue,
            "RESIZE_MODE_STRETCH": AVLayerVideoGravity.resize.rawValue
        ]
    }
}
