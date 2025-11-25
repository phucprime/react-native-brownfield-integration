/**
 * Babel configuration for MyRNFramework
 * 
 * This configuration is required for:
 * - Metro bundler to transpile JavaScript/TypeScript
 * - React Native brownfield integration
 * - XCFramework and AAR packaging via Rock CLI
 */
module.exports = {
  presets: ['module:@react-native/babel-preset'],
  plugins: [
    // Add any additional Babel plugins here
    // Example: ['@babel/plugin-proposal-decorators', { legacy: true }],
  ],
};
