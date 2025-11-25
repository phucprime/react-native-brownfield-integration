/**
 * MyRNFramework Entry Point
 *
 * This file registers React Native components that can be embedded
 * into existing native iOS and Android applications.
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from '../app.json';

AppRegistry.registerComponent(appName, () => App);
