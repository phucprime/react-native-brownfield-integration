/**
 * React Native Brownfield Integration Entry Point
 * 
 * This file registers React Native components that can be embedded
 * into existing native iOS and Android applications.
 */

import { AppRegistry } from 'react-native';
import BrownfieldScreen from './src/BrownfieldScreen';
import SharedFeature from './src/SharedFeature';

// Register the main brownfield screen component
// This name will be used by native code to load the React Native view
AppRegistry.registerComponent('BrownfieldScreen', () => BrownfieldScreen);

// Register additional shared features that can be used across native apps
AppRegistry.registerComponent('SharedFeature', () => SharedFeature);

// Export components for testing purposes
export { BrownfieldScreen, SharedFeature };
