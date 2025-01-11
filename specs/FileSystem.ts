import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface FileSystemSpec extends TurboModule {
  getDocumentDirectory(): Promise<string>;
}

export default TurboModuleRegistry.get<FileSystemSpec>('FileSystem');
