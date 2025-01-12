// VideoPlayerViewManager.swift
import Foundation

@objc(VideoPlayerViewManager)
class VideoPlayerViewManager: RCTViewManager {
    override func view() -> UIView {
        return VideoPlayerView()
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}

@objc(NativeVideoPlayer)
class NativeVideoPlayer: NSObject {
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc
    func getConstants() -> [String: Any] {
        return [
            "RESIZE_MODE_CONTAIN": "contain",
            "RESIZE_MODE_COVER": "cover",
            "RESIZE_MODE_STRETCH": "stretch"
        ]
    }
}
