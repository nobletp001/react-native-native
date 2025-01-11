// specs/ImagePicker.tsx
import React from 'react';
import { Text, TouchableOpacity, View, StyleSheet } from 'react-native';
import NativeImagePicker from '../specs/ImagePicker';

const ImagePickerModule = () => {
  const pickImage = async () => {
    try {
      const result = await NativeImagePicker?.pickImage();
      console.log('Selected image:', result);
    } catch (error) {
      console.error('Error picking image:', error);
    }
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity onPress={pickImage}>
        <Text>Pick an Image</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    padding: 16,
    margin: 16,
    borderWidth: 1,
    borderColor: 'gray',
    borderRadius: 8,
  },
});

export default ImagePickerModule;
