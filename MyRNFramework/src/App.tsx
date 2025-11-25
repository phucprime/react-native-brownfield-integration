/**
 * MyRNFramework App Component
 *
 * A sample React Native app for brownfield integration demonstrating:
 * - Counter demo with increment/decrement/reset buttons
 * - Input demo with greeting functionality
 * - Features list display
 * - Card-based styling
 */

import React, {useState, useCallback} from 'react';
import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  SafeAreaView,
  TextInput,
  ScrollView,
  Platform,
} from 'react-native';

interface Feature {
  id: string;
  title: string;
  description: string;
}

const FEATURES: Feature[] = [
  {
    id: '1',
    title: 'Framework Packaging',
    description: 'Package React Native as XCFramework (iOS) or AAR (Android)',
  },
  {
    id: '2',
    title: 'Reusable Components',
    description: 'Share React Native components across multiple native apps',
  },
  {
    id: '3',
    title: 'Native Navigation',
    description: 'Integrate with native navigation systems (UIKit, Jetpack)',
  },
  {
    id: '4',
    title: 'Hot Reloading',
    description: 'Fast development with Metro bundler hot reloading',
  },
  {
    id: '5',
    title: 'New Architecture',
    description: 'Support for React Native New Architecture with TurboModules',
  },
  {
    id: '6',
    title: 'Native Modules',
    description: 'Bridge native functionality to React Native components',
  },
];

const App: React.FC = () => {
  // Counter demo state
  const [count, setCount] = useState<number>(0);

  // Input demo state
  const [name, setName] = useState<string>('');
  const [greeting, setGreeting] = useState<string>('');

  const handleIncrement = useCallback(() => {
    setCount(prev => prev + 1);
  }, []);

  const handleDecrement = useCallback(() => {
    setCount(prev => prev - 1);
  }, []);

  const handleReset = useCallback(() => {
    setCount(0);
  }, []);

  const handleGreet = useCallback(() => {
    if (name.trim()) {
      setGreeting(`Hello, ${name.trim()}! Welcome to React Native Brownfield.`);
    } else {
      setGreeting('Please enter your name first.');
    }
  }, [name]);

  const renderFeatureItem = (feature: Feature) => (
    <View key={feature.id} style={styles.featureItem}>
      <Text style={styles.featureTitle}>{feature.title}</Text>
      <Text style={styles.featureDescription}>{feature.description}</Text>
    </View>
  );

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.headerTitle}>MyRNFramework</Text>
          <Text style={styles.headerSubtitle}>
            React Native Brownfield Integration
          </Text>
          <Text style={styles.platformText}>
            Running on: {Platform.OS} ({Platform.Version})
          </Text>
        </View>

        {/* Counter Demo Card */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>Counter Demo</Text>
          <Text style={styles.counterValue}>{count}</Text>
          <View style={styles.buttonRow}>
            <TouchableOpacity
              style={[styles.button, styles.decrementButton]}
              onPress={handleDecrement}
              activeOpacity={0.7}>
              <Text style={styles.buttonText}>−</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.button, styles.resetButton]}
              onPress={handleReset}
              activeOpacity={0.7}>
              <Text style={styles.buttonText}>Reset</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.button, styles.incrementButton]}
              onPress={handleIncrement}
              activeOpacity={0.7}>
              <Text style={styles.buttonText}>+</Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Input Demo Card */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>Input Demo</Text>
          <TextInput
            style={styles.input}
            placeholder="Enter your name..."
            placeholderTextColor="#999"
            value={name}
            onChangeText={setName}
            returnKeyType="done"
            onSubmitEditing={handleGreet}
          />
          <TouchableOpacity
            style={[styles.button, styles.greetButton]}
            onPress={handleGreet}
            activeOpacity={0.7}>
            <Text style={styles.buttonText}>Say Hello</Text>
          </TouchableOpacity>
          {greeting ? <Text style={styles.greetingText}>{greeting}</Text> : null}
        </View>

        {/* Features List Card */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>Features</Text>
          {FEATURES.map(renderFeatureItem)}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  scrollContent: {
    padding: 16,
  },
  header: {
    alignItems: 'center',
    marginBottom: 20,
    paddingVertical: 16,
  },
  headerTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#333',
  },
  headerSubtitle: {
    fontSize: 16,
    color: '#666',
    marginTop: 4,
  },
  platformText: {
    fontSize: 12,
    color: '#888',
    marginTop: 8,
  },
  card: {
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    padding: 20,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 2},
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  cardTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: '#333',
    marginBottom: 16,
    textAlign: 'center',
  },
  counterValue: {
    fontSize: 56,
    fontWeight: 'bold',
    color: '#007AFF',
    textAlign: 'center',
    marginBottom: 20,
  },
  buttonRow: {
    flexDirection: 'row',
    justifyContent: 'center',
    gap: 12,
  },
  button: {
    paddingVertical: 12,
    paddingHorizontal: 20,
    borderRadius: 8,
    minWidth: 60,
    alignItems: 'center',
    justifyContent: 'center',
  },
  decrementButton: {
    backgroundColor: '#FF3B30',
  },
  incrementButton: {
    backgroundColor: '#34C759',
  },
  resetButton: {
    backgroundColor: '#8E8E93',
  },
  greetButton: {
    backgroundColor: '#007AFF',
    marginTop: 12,
  },
  buttonText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  input: {
    borderWidth: 1,
    borderColor: '#DDD',
    borderRadius: 8,
    paddingHorizontal: 16,
    paddingVertical: 12,
    fontSize: 16,
    color: '#333',
    backgroundColor: '#FAFAFA',
  },
  greetingText: {
    marginTop: 16,
    fontSize: 16,
    color: '#34C759',
    textAlign: 'center',
    fontWeight: '500',
  },
  featureItem: {
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#F0F0F0',
  },
  featureTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#333',
    marginBottom: 4,
  },
  featureDescription: {
    fontSize: 14,
    color: '#666',
  },
});

export default App;
