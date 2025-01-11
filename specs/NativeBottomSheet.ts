// js/NativeBottomSheet.ts
import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface BottomSheetConfig {
  title?: string;
  message?: string;
  buttons?: Array<{
    title: string;
    style?: 'default' | 'cancel' | 'destructive';
  }>;
  height?: number; // percentage of screen height (0-100)
}

export interface Spec extends TurboModule {
  showBottomSheet(config: BottomSheetConfig): Promise<number>; // Returns selected button index
  dismissBottomSheet(): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('NativeBottomSheet');