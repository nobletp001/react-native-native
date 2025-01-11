import React from 'react';
import {
  SafeAreaView,
  Text,
  TextInput,
  TouchableOpacity,
  View,
  StyleSheet,
} from 'react-native';
import NativeLocalStorage from './specs/NativeLocalStorage';
import FileSystem from './specs/FileSystem';
const EMPTY = '<empty>';

function App(): React.JSX.Element {
  const [value, setValue] = React.useState<string | null>(null);
  const [editingValue, setEditingValue] = React.useState<string | null>(null);

  React.useEffect(() => {
    const storedValue = NativeLocalStorage?.getItem('myKey');
    setValue(storedValue ?? '');
  }, []);

  function saveValue() {
    NativeLocalStorage?.setItem(editingValue ?? EMPTY, 'myKey');
    setValue(editingValue);
  }
  const handleDocumentDirect = async ()=>{
    const documents = await FileSystem?.getDocumentDirectory();
  }

  function clearAll() {
    NativeLocalStorage?.clear();
    setValue('');
  }

  function deleteValue() {
    NativeLocalStorage?.removeItem('myKey');
    setValue('');
  }

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.inputContainer}>
        <Text style={styles.title}>Enter Username</Text>
        <TextInput
          style={styles.input}
          placeholder="Enter your username"
          value={editingValue ?? ''}
          onChangeText={setEditingValue}
        />
      </View>

      <View style={styles.buttonContainer}>
        <TouchableOpacity style={styles.button} onPress={saveValue}>
          <Text style={styles.buttonText}>Save Username</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.button} onPress={clearAll}>
          <Text style={styles.buttonText}>Clear All</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.button} onPress={deleteValue}>
          <Text style={styles.buttonText}>Delete Username</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.storedValueContainer}>
        <Text style={styles.storedValueTitle}>Stored Username:</Text>
        <Text style={styles.storedValue}>{value ?? 'No username saved'}</Text>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 16,
    backgroundColor: '#f5f5f5',
  },
  inputContainer: {
    marginBottom: 20,
    alignItems: 'center',
  },
  title: {
    fontSize: 20,
    fontWeight: '600',
    marginBottom: 10,
  },
  input: {
    height: 40,
    width: '80%',
    borderColor: '#ccc',
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 10,
    fontSize: 16,
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    width: '100%',
    marginBottom: 20,
  },
  button: {
    backgroundColor: '#6200ee',
    padding: 10,
    borderRadius: 8,
    margin: 5,
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
  },
  storedValueContainer: {
    marginTop: 20,
    alignItems: 'center',
  },
  storedValueTitle: {
    fontSize: 16,
    fontWeight: '500',
    marginBottom: 5,
  },
  storedValue: {
    fontSize: 18,
    fontWeight: '600',
    color: '#333',
  },
});

export default App;
