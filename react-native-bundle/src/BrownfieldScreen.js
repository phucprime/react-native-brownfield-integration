/**
 * BrownfieldScreen Component
 * 
 * A sample React Native screen designed for brownfield integration.
 * This component demonstrates how to create React Native UI that can
 * be embedded within existing native iOS and Android applications.
 */

import React, { useState, useCallback } from 'react';
import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  SafeAreaView,
  NativeModules,
  Platform,
} from 'react-native';

const BrownfieldScreen = ({ initialProps = {} }) => {
  const [counter, setCounter] = useState(0);
  const { title = 'React Native Brownfield Screen', message } = initialProps;

  const handleIncrement = useCallback(() => {
    setCounter(prev => prev + 1);
  }, []);

  const handleDecrement = useCallback(() => {
    setCounter(prev => prev - 1);
  }, []);

  const handleNativeNavigation = useCallback(() => {
    // Call back to native navigation if the bridge is available
    if (NativeModules.BrownfieldBridge) {
      NativeModules.BrownfieldBridge.navigateBack();
    }
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <Text style={styles.title}>{title}</Text>
        
        {message && <Text style={styles.message}>{message}</Text>}
        
        <Text style={styles.platformText}>
          Running on: {Platform.OS} ({Platform.Version})
        </Text>

        <View style={styles.counterContainer}>
          <Text style={styles.counterLabel}>Counter Demo</Text>
          <Text style={styles.counterValue}>{counter}</Text>
          
          <View style={styles.buttonRow}>
            <TouchableOpacity
              style={[styles.button, styles.decrementButton]}
              onPress={handleDecrement}
              activeOpacity={0.7}
            >
              <Text style={styles.buttonText}>-</Text>
            </TouchableOpacity>
            
            <TouchableOpacity
              style={[styles.button, styles.incrementButton]}
              onPress={handleIncrement}
              activeOpacity={0.7}
            >
              <Text style={styles.buttonText}>+</Text>
            </TouchableOpacity>
          </View>
        </View>

        <TouchableOpacity
          style={styles.navigationButton}
          onPress={handleNativeNavigation}
          activeOpacity={0.7}
        >
          <Text style={styles.navigationButtonText}>Return to Native</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  content: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 10,
    textAlign: 'center',
  },
  message: {
    fontSize: 16,
    color: '#666',
    marginBottom: 20,
    textAlign: 'center',
  },
  platformText: {
    fontSize: 14,
    color: '#888',
    marginBottom: 30,
  },
  counterContainer: {
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    padding: 20,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
    marginBottom: 30,
    width: '100%',
    maxWidth: 300,
  },
  counterLabel: {
    fontSize: 18,
    fontWeight: '600',
    color: '#333',
    marginBottom: 10,
  },
  counterValue: {
    fontSize: 48,
    fontWeight: 'bold',
    color: '#007AFF',
    marginBottom: 20,
  },
  buttonRow: {
    flexDirection: 'row',
    justifyContent: 'center',
  },
  button: {
    width: 60,
    height: 60,
    borderRadius: 30,
    justifyContent: 'center',
    alignItems: 'center',
    marginHorizontal: 15,
  },
  decrementButton: {
    backgroundColor: '#FF3B30',
  },
  incrementButton: {
    backgroundColor: '#34C759',
  },
  buttonText: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  navigationButton: {
    backgroundColor: '#007AFF',
    paddingVertical: 15,
    paddingHorizontal: 30,
    borderRadius: 8,
  },
  navigationButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#FFFFFF',
  },
});

export default BrownfieldScreen;
