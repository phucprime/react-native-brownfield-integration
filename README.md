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
│  │   ReactNativeBrownfield     │  │     │  │   ReactNativeBrownfield     │  │
│  │   (@callstack library)      │  │     │  │   (@callstack library)      │  │
│  └─────────────────────────────┘  │     │  └─────────────────────────────┘  │
│              │                    │     │              │                    │
│              ▼                    │     │              ▼                    │
│  ┌─────────────────────────────┐  │     │  ┌─────────────────────────────┐  │
│  │  ReactNativeView (SwiftUI)  │  │     │  │  Jetpack Compose / Activity │  │
│  │  ReactNativeViewController  │  │     │  │   (createView wrapper)      │  │
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
├── MyRNFramework/                      # React Native framework source
│   ├── src/App.tsx                     # React Native UI components
│   ├── index.ts                        # Entry point (AppRegistry.registerComponent)
│   ├── package.json                    # Dependencies & scripts
│   ├── ios/                            # iOS demo app
│   │   ├── Podfile
│   │   └── MyRNFramework/
│   │       ├── AppDelegate.swift       # ReactNativeBrownfield.shared.startReactNative()
│   │       ├── ReactNativeView.swift   # Re-exports library components
│   │       └── NativeModule.swift      # Custom native module example
│   └── android/                        # Android demo app
│       └── app/src/main/java/com/myrnframework/
│           ├── MainApplication.kt      # ReactNativeBrownfield.initialize()
│           └── MainActivity.kt         # ReactNativeBrownfield.shared.createView()
│
├── ios/                                # iOS native host app demo
│   ├── Podfile                         # CocoaPods (react-native-brownfield)
│   ├── RNBridge.xcodeproj/             # Xcode project
│   └── RNBridgeDemo/                   # Demo app source
│       ├── AppDelegate.swift           # ReactNativeBrownfield.shared.startReactNative()
│       └── ViewController.swift        # ReactNativeViewController usage
│
├── android/                            # Android native host app demo
│   ├── build.gradle                    # Root gradle config
│   ├── settings.gradle
│   └── app/
│       ├── build.gradle                # App dependencies
│       └── src/main/java/com/brownfield/rnbridge/demo/
│           ├── MainApplication.kt      # ReactNativeBrownfield.initialize()
│           └── MainActivity.kt         # ReactNativeBrownfield.shared.createView()
│
└── README.md
```

**Note:** This project uses `@callstack/react-native-brownfield` for all native bridge functionality.
No custom bridge code needed - the library provides everything:
- **iOS**: `ReactNativeBrownfield`, `ReactNativeView` (SwiftUI), `ReactNativeViewController` (UIKit)  
- **Android**: `ReactNativeBrownfield.initialize()`, `ReactNativeBrownfield.shared.createView()`

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
import ReactBrownfield

// 1. Initialize in AppDelegate
func application(_ application: UIApplication, 
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ReactNativeBrownfield.shared.startReactNative {
        print("React Native bundle loaded")
    }
    return true
}

// 2. Embed in SwiftUI (iOS 14.0+)
import SwiftUI
import ReactBrownfield

struct ContentView: View {
    var body: some View {
        ReactNativeView(moduleName: "MyRNFramework")
    }
}

// 3. Or use UIKit with ReactNativeViewController
let rnViewController = ReactNativeViewController(moduleName: "MyRNFramework")
navigationController?.pushViewController(rnViewController, animated: true)
```

### Android (Jetpack Compose)

```kotlin
import com.callstack.reactnativebrownfield.ReactNativeBrownfield

// 1. Initialize in Application.onCreate()
class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        val packages = PackageList(this).packages
        ReactNativeBrownfield.initialize(this, packages) { initialized ->
            Log.d("RN", "Bundle loaded: $initialized")
        }
    }
}

// 2. Embed in Jetpack Compose (requires FragmentActivity)
@Composable
fun ReactNativeComposeView(moduleName: String) {
    val activity = LocalContext.current as FragmentActivity
    AndroidView(
        factory = { _ ->
            ReactNativeBrownfield.shared.createView(activity, moduleName)
        }
    )
}
```

## Key Technologies

| Component | iOS | Android |
|-----------|-----|---------|
| **Framework** | XCFramework | AAR |
| **Bridge** | ReactNativeBrownfield | ReactNativeBrownfield |
| **UI Integration** | ReactNativeView (SwiftUI) / ReactNativeViewController (UIKit) | createView() (Compose/Activity) |
| **JS Engine** | Hermes | Hermes |
| **Bundler** | Metro | Metro |
| **Packaging** | Rock CLI | Rock CLI |

## Tools & Dependencies

- **[Rock CLI](https://www.rockjs.dev)** - Package React Native as native frameworks
- **[@callstack/react-native-brownfield](https://github.com/callstack/react-native-brownfield)** - Brownfield integration library

## License

MIT
