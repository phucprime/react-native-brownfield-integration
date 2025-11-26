const { pluginBrownfieldIos } = require("@rock-js/plugin-brownfield-ios");
const {
  pluginBrownfieldAndroid,
} = require("@rock-js/plugin-brownfield-android");
const { platformIOS } = require("@rock-js/platform-ios");

/** @type {import('rock').Config} */
module.exports = {
  platforms: {
    ios: platformIOS(),
  },
  plugins: [
    pluginBrownfieldIos({
      bundleIdentifier: "com.myrnframework",
      deploymentTarget: "15.1",
    }),
    pluginBrownfieldAndroid({
      packageName: "com.myrnframework",
      minSdkVersion: 24,
      targetSdkVersion: 35,
    }),
  ],
};
