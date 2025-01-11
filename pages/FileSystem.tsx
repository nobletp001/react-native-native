// specs/FileSystem.tsx
import React from 'react';
import { Text, TouchableOpacity, View, StyleSheet } from 'react-native';
import FileSystem from '../specs/FileSystem';

const FileSystemModule = () => {
  const [documentDirectory, setDocumentDirectory] = React.useState<string | null>(null);

  const getDocumentDirectory = async () => {
    const directory = await FileSystem?.getDocumentDirectory();
    if(directory){
        setDocumentDirectory(directory);
    }
  };

  return (
    <View style={styles.container}>
      <Text>Document Directory: {documentDirectory || 'Not fetched'}</Text>
      <TouchableOpacity onPress={getDocumentDirectory}>
        <Text>Fetch Document Directory</Text>
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

export default FileSystemModule;
