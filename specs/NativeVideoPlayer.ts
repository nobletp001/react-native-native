// js/NativeVideoPlayer.ts
import type { TurboModule } from 'react-native';
import type { ViewProps } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface VideoStatus {
  duration: number;
  currentTime: number;
  isPlaying: boolean;
  isBuffering: boolean;
}

interface NativeProps extends ViewProps {
  uri: string;
  paused?: boolean;
  muted?: boolean;
  volume?: number;
  resizeMode?: 'contain' | 'cover' | 'stretch';
}

export interface Spec extends TurboModule {
  getConstants(): { 
    RESIZE_MODE_CONTAIN: string;
    RESIZE_MODE_COVER: string;
    RESIZE_MODE_STRETCH: string;
  };
  
  // Native Component
  readonly VideoPlayerView: typeof import('react-native/Libraries/Components/View/ViewNativeComponent').default;
}

export default TurboModuleRegistry.getEnforcing<Spec>('NativeVideoPlayer');