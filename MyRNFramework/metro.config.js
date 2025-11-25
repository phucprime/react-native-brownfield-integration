/**
 * Metro configuration for MyRNFramework
 * 
 * This configuration is optimized for:
 * - React Native brownfield integration
 * - Framework packaging via Rock CLI
 * - TypeScript support
 * 
 * @see https://facebook.github.io/metro/docs/configuration
 * @see https://www.rockjs.dev/docs/brownfield/intro
 */

const {getDefaultConfig, mergeConfig} = require('@react-native/metro-config');

const defaultConfig = getDefaultConfig(__dirname);

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
  resolver: {
    // Add TypeScript extensions
    sourceExts: [...defaultConfig.resolver.sourceExts, 'tsx', 'ts'],
    // Asset extensions for bundling
    assetExts: defaultConfig.resolver.assetExts.filter(ext => ext !== 'svg'),
  },
  // For framework packaging, you may need to configure additional watchFolders
  // watchFolders: [],
};

module.exports = mergeConfig(defaultConfig, config);
