# React Native Brownfield Integration

Package React Native as a framework (XCFramework/AAR) and embed it into existing native iOS and Android applications.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        REACT NATIVE BROWNFIELD INTEGRATION                      │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              MyRNFramework/                                     │
│                       (React Native Framework Source)                           │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                                                                         │    │
│  │   src/App.tsx  ←──  React Native Components (JavaScript/TypeScript)     │    │
│  │   index.ts     ←──  Entry Point (AppRegistry.registerComponent)         │    │
│  │                                                                         │    │
│  └─────────────────────────────────────────────────────────────────────────┘    │
│                                    │                                            │
│                                    ▼                                            │
│  ┌──────────────────────────────────────────────────────────────────────────┐   │
│  │                      Metro Bundler / Rock CLI                            │   │
│  │                                                                          │   │
│  │   npm run bundle:ios      →  main.jsbundle (iOS)                         │   │
│  │   npm run bundle:android  →  index.android.bundle (Android)              │   │
│  │   npm run package:ios     →  MyRNFramework.xcframework                   │   │
│  │   npm run package:android →  myrnframework.aar                           │   │
│  │                                                                          │   │
│  └──────────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────────┘
                                    │
            ┌───────────────────────┴───────────────────────┐
            │                                               │
            ▼                                               ▼
┌───────────────────────────────────┐     ┌───────────────────────────────────┐
│         iOS Native App            │     │       Android Native App          │
│    (Host Application - Swift)     │     │   (Host Application - Kotlin)     │
├───────────────────────────────────┤     ├───────────────────────────────────┤
│                                   │     │                                   │
│  ┌─────────────────────────────┐  │     │  ┌─────────────────────────────┐  │
│  │   XCFramework / CocoaPods   │  │     │  │   AAR / Gradle Dependency   │  │
│  │   + main.jsbundle           │  │     │  │   + index.android.bundle    │  │
│  └─────────────────────────────┘  │     │  └─────────────────────────────┘  │
│              │                    │     │              │                    │
│              ▼                    │     │              ▼                    │
│  ┌─────────────────────────────┐  │     │  ┌─────────────────────────────┐  │
│  │     RCTReactNativeFactory   │  │     │  │  ReactNativeBrownfieldShared│  │
│  │     (React Native Bridge)   │  │     │  │     (React Native Bridge)   │  │
│  └─────────────────────────────┘  │     │  └─────────────────────────────┘  │
│              │                    │     │              │                    │
│              ▼                    │     │              ▼                    │
│  ┌─────────────────────────────┐  │     │  ┌─────────────────────────────┐  │
│  │    SwiftUI / UIKit View     │  │     │  │  Jetpack Compose / Activity │  │
│  │  (ReactNativeView wrapper)  │  │     │  │   (ReactRootView wrapper)   │  │
│  └─────────────────────────────┘  │     │  └─────────────────────────────┘  │
│              │                    │     │              │                    │
│              ▼                    │     │              ▼                    │
│  ┌─────────────────────────────┐  │     │  ┌─────────────────────────────┐  │
│  │    Native App UI (Swift)    │  │     │  │   Native App UI (Kotlin)    │  │
│  │    Navigation, Screens...   │  │     │  │   Navigation, Screens...    │  │
│  └─────────────────────────────┘  │     │  └─────────────────────────────┘  │
│                                   │     │                                   │
└───────────────────────────────────┘     └───────────────────────────────────┘
```

## Project Structure

```
react-native-brownfield-integration/
├── MyRNFramework/              # React Native framework source
│   ├── src/App.tsx             # React Native UI components
│   ├── index.ts                # Entry point
│   ├── package.json            # Dependencies & scripts
│   ├── ios/                    # iOS demo (runnable with RN bundled)
│   │   ├── MyRNFramework.xcodeproj
│   │   ├── Podfile
│   │   └── MyRNFramework/
│   │       ├── AppDelegate.swift
│   │       ├── ReactNativeView.swift
│   │       └── NativeModule.swift
│   └── android/                # Android demo (runnable with RN bundled)
│       ├── app/build.gradle
│       └── src/main/java/com/myrnframework/
│           ├── MainActivity.kt
│           └── MainApplication.kt
│
├── ios/                        # iOS native host app demo (RNBridge library)
│   ├── RNBridge.xcodeproj      # Xcode project
│   ├── Podfile                 # CocoaPods dependencies
│   ├── RNBridge/               # Bridge library source
│   │   ├── RNBridgeManager.swift
│   │   ├── RNBridgeViewController.swift
│   │   └── BrownfieldBridgeModule.swift
│   └── RNBridgeDemo/           # Demo app source
│       ├── AppDelegate.swift
│       ├── ViewController.swift
│       └── Main.storyboard
│
├── android/                    # Android native host app demo (RNBridge library)
│   ├── build.gradle
│   ├── settings.gradle
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       └── java/com/brownfield/
│   │           ├── rnbridge/           # Bridge library
│   │           │   ├── RNBridgeManager.kt
│   │           │   ├── RNBridgeActivity.kt
│   │           │   └── BrownfieldBridgeModule.kt
│   │           └── rnbridge/demo/      # Demo app
│   │               ├── MainActivity.kt
│   │               └── MainApplication.kt
│
└── README.md
```

## Quick Start

### Option 1: Run MyRNFramework (React Native bundled app)

```bash
cd MyRNFramework
npm install

# iOS
cd ios && pod install && cd ..
npx react-native run-ios

# Android
npx react-native run-android
```

### Option 2: Run Native Host Apps (ios/ & android/ folders)

These are native iOS/Android apps that demonstrate embedding React Native views:

```bash
# First, install RN dependencies
cd MyRNFramework && npm install && cd ..

# iOS (requires Xcode)
cd ios && pod install && cd ..
open ios/RNBridge.xcodeproj  # Build & run RNBridgeDemo target

# Android (requires Android Studio)
cd android && ./gradlew assembleDebug
# Or open android/ in Android Studio and run
```

### 3. Build for Production

```bash
# Bundle JavaScript
npm run bundle:ios
npm run bundle:android

# Package as framework (requires Rock CLI)
npm run package:ios      # → XCFramework
npm run package:android  # → AAR
```

## Integration into Existing Native Apps

### iOS (SwiftUI)

```swift
// 1. Initialize in AppDelegate
let delegate = ReactNativeDelegate()
reactNativeFactory = RCTReactNativeFactory(delegate: delegate)

// 2. Embed in SwiftUI
struct ContentView: View {
    var body: some View {
        ReactNativeView(moduleName: "MyRNFramework")
    }
}
```

### Android (Jetpack Compose)

```kotlin
// 1. Initialize in Application
ReactNativeBrownfieldShared.startReactNative(this, "index.android.bundle")

// 2. Embed in Compose
@Composable
fun MainScreen() {
    ReactNativeScreen(moduleName = "MyRNFramework")
}
```

## Key Technologies

| Component | iOS | Android |
|-----------|-----|---------|
| **Framework** | XCFramework | AAR |
| **Bridge** | RCTReactNativeFactory | ReactNativeBrownfieldShared |
| **UI Integration** | SwiftUI / UIKit | Jetpack Compose / Activity |
| **JS Engine** | Hermes | Hermes |
| **Bundler** | Metro | Metro |
| **Packaging** | Rock CLI | Rock CLI |

## Tools & Dependencies

- **[Rock CLI](https://www.rockjs.dev)** - Package React Native as native frameworks
- **[@callstack/react-native-brownfield](https://github.com/callstack/react-native-brownfield)** - Brownfield integration library

## License

MIT
