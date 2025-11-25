/**
 * Metro configuration for MyRNFramework
 * 
 * This configuration is optimized for:
 * - React Native 0.78+ brownfield integration
 * - Framework packaging via Rock CLI
 * - TypeScript support (built-in for RN 0.78+)
 * 
 * @see https://reactnative.dev/docs/metro
 * @see https://www.rockjs.dev/docs/brownfield/intro
 * @type {import('@react-native/metro-config').MetroConfig}
 */

const {getDefaultConfig, mergeConfig} = require('@react-native/metro-config');

const config = {
  transformer: {
    // Enable inline requires for better startup performance
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
  },
  // TypeScript extensions are built-in for RN 0.78+
  // For framework packaging, you may need to configure additional watchFolders
  // watchFolders: [],
};

module.exports = mergeConfig(getDefaultConfig(__dirname), config);
