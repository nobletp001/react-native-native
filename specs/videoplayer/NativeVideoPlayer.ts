// js/NativeVideoPlayer.ts
import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  getConstants(): {
    RESIZE_MODE_CONTAIN: string;
    RESIZE_MODE_COVER: string;
    RESIZE_MODE_STRETCH: string;
  };
}

// Export as a constant instead of default export
export const NativeVideoPlayer = TurboModuleRegistry.getEnforcing<Spec>('NativeVideoPlayer');