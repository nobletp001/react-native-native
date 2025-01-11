// js/NativeImagePicker.ts
import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface ImageResult {
  uri: string;
  width: number;
  height: number;
  fileSize: number;
  fileName: string;
  type: string;
}

export interface Spec extends TurboModule {
  pickImage(): Promise<ImageResult>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('NativeImagePicker');