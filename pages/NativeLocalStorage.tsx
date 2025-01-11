// specs/NativeLocalStorage.tsx
import React from 'react';
import { Text, TouchableOpacity, StyleSheet, View } from 'react-native';
import NativeLocalStorage from '../specs/NativeLocalStorage';

const LocalStorageModule = () => {
  const [storedValue, setStoredValue] = React.useState<string | null>(null);

  React.useEffect(() => {
    const value = NativeLocalStorage?.getItem('myKey');
    setStoredValue(value ?? 'No value stored');
  }, []);

  const saveValue = () => {
    NativeLocalStorage?.setItem('sampleValue', 'myKey');
    setStoredValue('sampleValue');
  };

  const clearValue = () => {
    NativeLocalStorage?.clear();
    setStoredValue('No value stored');
  };

  const deleteValue = () => {
    NativeLocalStorage?.removeItem('myKey');
    setStoredValue('No value stored');
  };

  return (
    <View style={styles.container}>
      <Text>Stored Value: {storedValue}</Text>
      <TouchableOpacity onPress={saveValue}>
        <Text>Save Value</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={clearValue}>
        <Text>Clear Value</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={deleteValue}>
        <Text>Delete Value</Text>
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

export default LocalStorageModule;
