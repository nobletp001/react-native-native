// specs/NativeBottomSheet.tsx
import React from 'react';
import { Text, TouchableOpacity, View, StyleSheet } from 'react-native';
import NativeBottomSheet from '../specs/NativeBottomSheet';

const BottomSheetModule = () => {
  const showBottomSheet = async () => {
    try {
      const selectedIndex = await NativeBottomSheet?.showBottomSheet({
        title: 'Select an Option',
        message: 'Choose from the following options:',
        height: 40,
        buttons: [
          { title: 'Option 1', style: 'default' },
          { title: 'Option 2', style: 'default' },
          { title: 'Delete', style: 'destructive' },
          { title: 'Cancel', style: 'cancel' },
        ],
      });
      console.log('Selected button index:', selectedIndex);
    } catch (error) {
      console.error('Error showing bottom sheet:', error);
    }
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity onPress={showBottomSheet}>
        <Text>Show Bottom Sheet</Text>
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

export default BottomSheetModule;
