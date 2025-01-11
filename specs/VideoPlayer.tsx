// js/VideoPlayer.tsx
import React, { useEffect, useRef } from 'react';
import { requireNativeComponent, ViewProps, NativeEventEmitter, Platform } from 'react-native';

interface VideoPlayerProps extends ViewProps {
  uri: string;
  paused?: boolean;
  muted?: boolean;
  volume?: number;
  resizeMode?: 'contain' | 'cover' | 'stretch';
  onLoad?: (event: { duration: number }) => void;
  onProgress?: (event: { currentTime: number }) => void;
  onBuffer?: (event: { isBuffering: boolean }) => void;
  onEnd?: () => void;
  onError?: (error: { message: string }) => void;
}

const NativeVideoPlayerView = requireNativeComponent<VideoPlayerProps>('RCTVideoPlayerView');

const VideoPlayer: React.FC<VideoPlayerProps> = ({
  uri,
  paused = false,
  muted = false,
  volume = 1,
  resizeMode = 'contain',
  onLoad,
  onProgress,
  onBuffer,
  onEnd,
  onError,
  style,
  ...props
}) => {
  const eventEmitterRef = useRef<NativeEventEmitter>();

  useEffect(() => {
    const NativeVideoPlayer = require('./NativeVideoPlayer').default;
    eventEmitterRef.current = new NativeEventEmitter(NativeVideoPlayer);

    const subscriptions = [
      eventEmitterRef.current.addListener('onVideoLoad', onLoad),
      eventEmitterRef.current.addListener('onVideoProgress', onProgress),
      eventEmitterRef.current.addListener('onVideoBuffer', onBuffer),
      eventEmitterRef.current.addListener('onVideoEnd', onEnd),
      eventEmitterRef.current.addListener('onVideoError', onError)
    ];

    return () => {
      subscriptions.forEach(subscription => subscription.remove());
    };
  }, [onLoad, onProgress, onBuffer, onEnd, onError]);

  return (
    <NativeVideoPlayerView
      style={[{ flex: 1 }, style]}
      uri={uri}
      paused={paused}
      muted={muted}
      volume={volume}
      resizeMode={resizeMode}
      {...props}
    />
  );
};

export default VideoPlayer;