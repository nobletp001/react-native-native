// js/types.ts
import type { ViewProps } from 'react-native';

export interface VideoStatus {
  duration: number;
  currentTime: number;
  isPlaying: boolean;
  isBuffering: boolean;
}

export interface VideoPlayerProps extends ViewProps {
  uri: string;
  paused?: boolean;
  muted?: boolean;
  volume?: number;
  resizeMode?: 'contain' | 'cover' | 'stretch';
  onStatusUpdate?: (event: { nativeEvent: VideoStatus }) => void;
  onError?: (event: { nativeEvent: { error: string } }) => void;
}

// Define native component props separately to avoid circular dependencies
export interface NativeVideoPlayerProps extends VideoPlayerProps {
  // Add any additional native-specific props here if needed
}