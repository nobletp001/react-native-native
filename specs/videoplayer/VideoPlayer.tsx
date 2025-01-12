// js/VideoPlayer.tsx
import React from 'react';
import { requireNativeComponent } from 'react-native';
import type { VideoPlayerProps, NativeVideoPlayerProps } from './types';

const NativeVideoPlayerView = requireNativeComponent<NativeVideoPlayerProps>('VideoPlayerView');

export const VideoPlayer: React.FC<VideoPlayerProps> = (props) => {
  return <NativeVideoPlayerView {...props} />;
};

// Default export for easier imports
export default VideoPlayer;