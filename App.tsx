// App.tsx
import React from 'react';
import { SafeAreaView, ScrollView, StyleSheet } from 'react-native';
import LocalStorageModule from './pages/NativeLocalStorage';
import FileSystemModule from './pages/FileSystem';
import ImagePickerModule from './pages/NativeImagePicker';
import BottomSheetModule from './pages/NativeBottomSheet';


const App = () => {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollView}>
        {/* <LocalStorageModule />
        <FileSystemModule />
        <ImagePickerModule /> */}
        <BottomSheetModule />
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  scrollView: {
    padding: 16,
  },
});

export default App;
